function activity_recognition_demo(numStateZ,C,E,thres,baseFile,options,alterProb,numCores)
%ACTIVITY_RECOGNITION_DEMO  an example for running this software
%
% INPUT PARAMETERS:
%
%   numStateZ  number of latent varibles, N_z in the paper
%    
%   C          SVM parameter, C serves as the normalization constant
%
%   E          SVM parameter, \epsilon
%
%   thres      Stop threshold for Concave Convex Procedure (CCCP)    
%
%   baseFile   Name of the dataset to be used. The video is discretized
%              and each segment is represents as a node in the graphical 
%              model. Three segmentation strategies are used. GROUNDTRUTH 
%              SEGMENTAION is annotated by hand. UNIFORM SEGMENTAION
%              creates segments with fixed length. GRAPH-BASED 
%              SEGMENTAION segments the video based on frame similarity.
%
%              GROUNDTRUTH SEGMENTAION:
%              'groundtruth'
%              
%              UNIFORM SEGMENTAION: Uniformly segment videos into 
%              'uniform_20_0', 'uniform_20_10', 'uniform_20_15',
%              'uniform_30_10', 'uniform_40_10'
%              
%              GRAPH-BASED SEGMENTAION:
%              'm1_100', 'm1_500', 'm1_1000', 'm2_100', 'm2_500', 'm2_1000'
%
%   options    'corrupt' or 'flip'
%   alterProb  amount of noise in labels, real number from 0 to 1
%   numCores   number of cores used
%
% OUTPUT FILES:
%
%   learned model    model_<baseFile>_<List of parameters>.mat"
%
%   log file         <baseFile>_<List of parameters>.log"
%
%   results          <baseFile>_<List of parameters>_<iteration No.>.mat  
%

save_on = 1;

% convert input string to real numbers. For super computer users, the
% matlab script may need to be compile into binary files, which only accept
% strings as input. This part is to convert them from input string to numbers
if ischar(C)
  C = str2double(C);
  E = str2double(E);
  numStateZ = str2double(numStateZ);
  thres = str2double(thres);
  alterProb = str2double(alterProb);
  numCores = str2double(numCores);
  assert(alterProb <= 1 && alterProb >= 0)
end

% add global path
set_global_path;

% start matlab parallel computing if more than 1 core is specified
start_matlabpool(numCores)

% SVM^struct parameters
W = 3; % optimization strategy
tfeat = 'tfeat_on';
initStrategy = 'learning'; % initialization strategy
numFolds = 4; % 4-fold cross-validation

% Flag indicate any missing label
hasPartialLabel = strcmp(options,'corrupt') && alterProb > 0;

% any latent value? (either missing label or latent variable)
hasLatent = hasPartialLabel || numStateZ > 1 ;

if hasLatent
  eval_set = 1:3;
else
  eval_set = 1; % stop after 1 iteration if the process is deterministic
end

baseFolder = fullfile(pwd,'CAD120','segmentation_lists');
path = fullfile(baseFolder,baseFile);
dirResults = sprintf('opt_%s_Prob_%.2f_%s_C%.2f_E%.2f_W%d_%s_Thre%.1f_%s',...
  options,alterProb,baseFile,C,E,W,tfeat,thres,initStrategy); % folder to save results
mkdir(dirResults);

%%% allocate buffer for storing results %%%
% evaluation is iterated for length(eval_set) times.
trainRate = nan(numFolds,length(eval_set)); % accuracy on training
testRate = nan(numFolds,length(eval_set)); % accuracy on testing
prec = nan(numFolds,length(eval_set)); % precision on testing
recall = nan(numFolds,length(eval_set)); % recall on testing
fscore = nan(numFolds,length(eval_set)); % f1-score on testing
confmat = cell(numFolds,length(eval_set)); % confusion matrix
trainRateUpper = nan(numFolds,length(eval_set)); % high-level accuracy on training
testRateUpper = nan(numFolds,length(eval_set)); % high-level accuracy on testing

% 4 fold cross-validation - leave-one-subject out
combos = combntns(1:numFolds,3);

%%  MAIN LOOP
%   We use 4-fold cross validation and each cross validation is repeated
%   for length(eval_set) times

for c = 1 : length(eval_set)

  iter = eval_set(c);
  filebase = sprintf('%s_Z%d_C%.2f_E%.2f_W%d_%s_Thre%.1f_%s_iter%d'...
      ,baseFile,numStateZ,C,E,W,tfeat,thres,initStrategy,iter);

  %%% 4-fold cross-validation %%%
  % each fold trains on three human actors and test on the other
  for i = 1 : size(combos,1) % change for to parfor if parallel computing

    % select video for training set
    train_sid = combos(i,:);
    all_sid = 1 : 4;
    test_sid = all_sid(~ismember(all_sid,train_sid));

    if save_on
      logfile = fullfile(dirResults,sprintf([filebase,'_Test%d'],test_sid));
      make_log(logfile); % LOG file
    end

    % load structured svm options
    learning_option = sprintf('-c %.2f -e %.2f -w %d',C,E,W); % ssvm learning parameters

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % split training and test data
    % REPLACE THIS FUNCTION IF YOU WANT TO USE OTHER DATASET
    [trainData,testData] = load_CAD120(tfeat,train_sid,path);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % options for corruptLabels and FlipLabels
    if strcmp(options,'corrupt')
      trainData = corruptLabels(trainData,alterProb);
    elseif strcmp(options,'flip')
      trainData = flipLabels(trainData,alterProb);
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
    if save_on
      fsave = fullfile(dirResults,['model_',sprintf([filebase,'_Test%d'],test_sid),'.mat']);
      isave(fsave,model,params,train_sid,test_sid,trainData.nanIdx);
    end
%     load(fullfile(dirResults,['model_',sprintf([filebase,'_Test%d'],test_sid),'.mat']),'model','params','trainData','testData')


    %%% classification %%%

    % training data
    [~,~,trainRate(i,c)] = evaluate_model(trainData, model, params);

    % test data
    [gt_labels,pred_labels,testRate(i,c)] = evaluate_model(testData, model, params);
    [confmat{i,c}, prec(i,c), recall(i,c), fscore(i,c)] = prec_recall(gt_labels,pred_labels);

    numStateZmulti = 1;
    [trainRateUpper(i,c),testRateUpper(i,c)] = multi_class_svm(model,params,trainData,testData,numStateZmulti);

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
  results.meanTrainUpper = mean2(trainRateUpper);
  results.trainRateUpper = trainRateUpper;
  results.meanTestUpper = mean2(testRateUpper);
  results.testRateUpper = testRateUpper;

  if save_on
    save(fullfile(dirResults,[filebase,'.mat']),'results');
  end

end

if numCores > 1
  matlabpool close;
end

end
