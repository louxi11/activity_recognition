function semi_supervised_template(numStateZ,C,E,thres,baseFile,corruptPercentage,par_on)

clc
% clear all
diary off

options = 'flip';

if strcmp(par_on,'true')
  if matlabpool('size') == 0
    matlabpool open
  end
  fprintf('Using %d cores\n',matlabpool('size'));
end

if (~isdeployed)
  addpath graphical_model/
  addpath inference/
  addpath learning
  addpath svm-struct-matlab-1.2/
  addpath tools/
  addpath evaluation/

  addpath test_data/
  addpath test_data/CAD120/
end

save_on = 1;

% SVM^struct parameters
W = 3; % optimization strategy
tfeat = 'tfeat_on';
initStrategy = 'learning'; % semi supervised
if ischar(corruptPercentage)
  corruptPercentage = eval(corruptPercentage); % mcc binary functions takes inf as string
  C = str2double(C);
  E = str2double(E);
  numStateZ = str2double(numStateZ);
  thres = str2double(thres);
end

hasPartialLabel = strcmp(options,'corrupt') && corruptPercentage > 0;
hasLatent = hasPartialLabel || numStateZ > 1 ;

eval_set = 1:3;
baseFolder = fullfile(pwd,'CAD120/segmentation_lists');
path = fullfile(baseFolder,baseFile);


%%% allocate buffer %%%
trainRate = nan(4,length(eval_set));
testRate = nan(4,length(eval_set));
prec = nan(4,length(eval_set));
recall = nan(4,length(eval_set));
fscore = nan(4,length(eval_set));
confmat = cell(4,length(eval_set));

% 4 fold cross-validation - leave one subject out
combos = combntns(1:4,3);

dirResults = sprintf('%s_cp_%.2f_C%.2f_E%.2f_W%d_%s_Thre%.1f_%s',...
  baseFile,corruptPercentage,C,E,W,tfeat,thres,initStrategy);
mkdir(dirResults);

% replicate cross-validation
for c = 1 : length(eval_set)

  iter = eval_set(c);
  filebase = sprintf('%s_Z%d_cp_%.2f_C%.2f_E%.2f_W%d_%s_Thre%.1f_%s_iter%d'...
      ,baseFile,numStateZ,corruptPercentage,C,E,W,tfeat,thres,initStrategy,iter);

  %%% cross-validation in parallel %%%
  parfor i = 1 : size(combos,1)

    % select video for training set
    train_sid = combos(i,:);
    all_sid = 1 : 4;
    test_sid = all_sid(~ismember(all_sid,train_sid));


    if save_on
      logfile = fullfile(dirResults,sprintf([filebase,'_Test%d'],test_sid));
      make_log(logfile); % LOG file and SAVE MODEL
    end

    % load structured svm options
    learning_option = sprintf('-c %.2f -e %.2f -w %d',C,E,W); % ssvm learning parameters

    % split training and test data
    [trainData,testData] = load_CAD120(tfeat,train_sid,path);
    
    % options for corruptLabels and FlipLabels
    if strcmp(options,'corrupt')
      trainData = corruptLabels(trainData,corruptPercentage);
    elseif strcmp(options,'flip')
      trainData = flipLabels(trainData,5); %% TODO
    end

    %%% initilize unknown labels by learning with known data
    model = [];
    if strcmp(initStrategy,'learning') && hasPartialLabel
      splitData = splitDataAtNan(trainData);
      [model,~] = learning_CAD120(splitData,numStateZ,learning_option,thres,initStrategy,C,model,hasPartialLabel,hasLatent);
    end

    % learning
    [model,params] = learning_CAD120(trainData,numStateZ,learning_option,thres,initStrategy,C,model,hasPartialLabel,hasLatent);

    % save model to file
%     if save_on
%       save(fullfile(dirResults,['model_',sprintf([filebase,'_Test%d'],test_sid),'.mat']),'model','params','trainData','testData')
%     end
    %     load(['model_',logfile,'.mat'],'model','params','trainData','testData')



    %%% classification %%%

    data = trainData;
    D = zeros(size(data.patterns));
    for j = 1 : length(data.patterns)
      X_train = data.patterns{j};
      yhat = ssvm_classify(params, model, X_train); % TODO bugs for classification
      D(j) = sum( int32(data.labels{j}) == int32(yhat));
    end
    labels = cellfun(@transpose,data.labels,'UniformOutput',false);
    labels = [labels{:}];
    CNT = sum(~isnan(labels));
    trainRate(i,c) = sum(D)/CNT;

    D = zeros(size(data.patterns));
    PRED = cell(size(data.patterns));
    data = testData;
    for j = 1 : length(data.patterns)
      X_test = data.patterns{j};
      yhat = ssvm_classify(params, model, X_test);
      PRED{j} = yhat';
      D(j) = sum( int32(data.labels{j}) == int32(yhat));
    end
    labels = cellfun(@transpose,data.labels,'UniformOutput',false);
    GT = [labels{:}]';
    CNT = sum(~isnan(GT));
    PRED = [PRED{:}]';
    testRate(i,c) = sum(D)/CNT;

    [~, prec0, recall0, confmat0] = prec_recall(GT,PRED);
    prec(i,c) = mean(prec0);
    recall(i,c) = mean(recall0);
    fscore(i,c) = 2 * prec(i,c) * recall(i,c) / (prec(i,c) + recall(i,c));
    confmat{i,c} = confmat0;

    fprintf('******************************\n')
    fprintf('Training set: %d, %d, %d\n',train_sid(1),train_sid(2),train_sid(3));
    fprintf('Training rate: %.4f\n\n',trainRate(i,c));

    fprintf('Test set: %d\n',test_sid);
    fprintf('Test rate: %.4f\n',testRate(i,c));
    fprintf('Test precision: %.4f\n',prec(i,c));
    fprintf('Test recall: %.4f\n',recall(i,c));
    fprintf('Test Fscore: %.4f\n',fscore(i,c));
    fprintf('******************************\n\n')

    diary off

  end    
    
  results.meanTrain = mean(trainRate(:));
  results.stdTrain = std(trainRate(:));
  results.meanTest = mean(testRate(:));
  results.stdTest = std(testRate(:));

  results.meanPrec = mean(prec(:));
  results.stdPrec = std(prec(:));
  results.meanRecall = mean(recall(:));
  results.stdRecall = std(recall(:));
  results.meanFscore = mean(fscore(:));
  results.stdFscore = std(fscore(:));

  if save_on
    save(fullfile(dirResults,[filebase,'.mat']),...
      'trainRate','testRate','results','prec','recall','fscore','confmat');
  end

  if ~hasLatent
    results.meanTrain = nanmean(trainRate(:));
    results.stdTrain = nanstd(trainRate(:));
    results.meanTest = nanmean(testRate(:));
    results.stdTest = nanstd(testRate(:));
    
    results.meanPrec = nanmean(prec(:));
    results.stdPrec = nanstd(prec(:));
    results.meanRecall = nanmean(recall(:));
    results.stdRecall = nanstd(recall(:));
    results.meanFscore = nanmean(fscore(:));
    results.stdFscore = nanstd(fscore(:));
    break
  end
  
end

if strcmp(par_on,'true')
  matlabpool close;
end

end
