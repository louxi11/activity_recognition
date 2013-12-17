function semi_supervised_template(numStateZ,C,E,thres,baseFile,options,flipProb,numCores)

save_on = 1;

if ischar(C)
  C = str2double(C);
  E = str2double(E);
  numStateZ = str2double(numStateZ);
  thres = str2double(thres);
  flipProb = str2double(flipProb);
  numCores = str2double(numCores);
  assert(flipProb <= 1 && flipProb >= 0)
end

set_global_path;
start_matlabpool(numCores)

% SVM^struct parameters
W = 3; % optimization strategy
tfeat = 'tfeat_on';
initStrategy = 'learning'; % semi-supervised
numFolds = 4; % 4-fold cross-validation

hasPartialLabel = strcmp(options,'corrupt') && flipProb > 0;
hasLatent = hasPartialLabel || numStateZ > 1 ;

if hasLatent
  eval_set = 1:3;
else
  eval_set = 1; % stop after 1 iteration if the process is deterministic
end

baseFolder = fullfile(pwd,'CAD120/segmentation_lists');
path = fullfile(baseFolder,baseFile);
dirResults = sprintf('opt_%s_Prob_%.2f_%s_C%.2f_E%.2f_W%d_%s_Thre%.1f_%s',...
  options,flipProb,baseFile,C,E,W,tfeat,thres,initStrategy);
mkdir(dirResults);

%%% allocate buffer %%%
trainRate = nan(numFolds,length(eval_set));
testRate = nan(numFolds,length(eval_set));
prec = nan(numFolds,length(eval_set));
recall = nan(numFolds,length(eval_set));
fscore = nan(numFolds,length(eval_set));
confmat = cell(numFolds,length(eval_set));

% 4 fold cross-validation - leave-one-subject out
combos = combntns(1:numFolds,3);

% replicate cross-validation
for c = 1 : length(eval_set)

  iter = eval_set(c);
  filebase = sprintf('%s_Z%d_C%.2f_E%.2f_W%d_%s_Thre%.1f_%s_iter%d'...
      ,baseFile,numStateZ,C,E,W,tfeat,thres,initStrategy,iter);

  %%% cross-validation in parallel %%%
  for i = 1 : size(combos,1)

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
      trainData = corruptLabels(trainData,flipProb);
    elseif strcmp(options,'flip')
      trainData = flipLabels(trainData,flipProb);
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
%     load(fullfile(dirResults,['model_',sprintf([filebase,'_Test%d'],test_sid),'.mat']),'model','params','trainData','testData')


    %%% classification %%%
    
    % training data
    [~,~,trainRate(i,c)] = evaluate_model(trainData, model, params);
    
    % test data
    [gt_labels,pred_labels,testRate(i,c)] = evaluate_model(testData, model, params);
    [confmat{i,c}, prec(i,c), recall(i,c), fscore(i,c)] = prec_recall(gt_labels,pred_labels);

    % output results
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
    
  results = collect_results(trainRate,testRate,prec,recall,fscore);
  if save_on
    save(fullfile(dirResults,[filebase,'.mat']),'results');
  end

end

if numCores > 1
  matlabpool close;
end
  
end
