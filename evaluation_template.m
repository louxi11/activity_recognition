% function evaluation_template

clc
clear all

addpath graphical_model/
addpath inference/
addpath learning
addpath svm-struct-matlab-1.2/
addpath tools/
addpath evaluation/

addpath test_data/

save_on = 1;

%%% parameters %%%
numStateZ = 1;
C = 0.3; % normalization constant
E = 0.25; % epsilon
W = 3; % optimization strategy
tfeat = 'tfeat_on';
thres = inf; % threshold to stop iteration TODO
initStrategy = 'affordance';

eval_set = 1;

%%% allocate buffer %%%
trainRate = nan(4,length(eval_set));
testRate = nan(4,length(eval_set));

combos = combntns(1:4,3);

for iter = 1 : length(eval_set)
  
  GT = [];
  PRED = [];
  
  %%% learning %%%
  for i = 1 : size(combos,1)
    
    % select video for training set
    train_sid = combos(i,:);
    all_sid = 1 : 4;
    test_sid = all_sid(~ismember(all_sid,train_sid));
    
    filebase = sprintf('Z%d_C%.2f_E%.2f_W%d_%s_Thre%.1f_%s_iter%d',numStateZ,C,E,W,tfeat,thres,initStrategy,iter);
    if save_on
      logfile = sprintf([filebase,'_Test%d'],test_sid);
      make_log(logfile); % LOG file and SAVE MODEL
    end
    
    % load structured svm options
    learning_option = sprintf('-c %.2f -e %.2f -w %d',C,E,W); % ssvm learning parameters
    
    % split training and test data
    [trainData,testData] = load_CAD120('parse_off',tfeat,train_sid);
    
    % learning
    [model,params] = learning_CAD120(trainData,numStateZ,learning_option,thres,initStrategy);
    
    % save model to file
    if save_on
      save(['model_',logfile,'.mat'],'model','params','trainData','testData')
    end
    
    %%% classification %%%
    
    CNT = 0;
    D = 0;
    data = trainData;
    for j = 1 : length(data.patterns)
      X_test = data.patterns{j};
      yhat = ssvm_classify(params, model, X_test);
      D = D + sum( int32(data.labels{j}) == int32(yhat));
      CNT = CNT + length(data.labels{j});
    end
    trainRate(i,iter) = D/CNT;
    
    CNT = 0;
    D = 0;
    data = testData;
    for j = 1 : length(data.patterns)
      X_test = data.patterns{j};
      yhat = ssvm_classify(params, model, X_test);
      GT = [GT;data.labels{j}];
      PRED = [PRED;yhat];
      D = D + sum( int32(data.labels{j}) == int32(yhat));
      CNT = CNT + length(data.labels{j});
    end
    testRate(i,iter) = D/CNT;
    
    fprintf('******************************\n')
    fprintf('Training set: %d, %d, %d\n',train_sid(1),train_sid(2),train_sid(3));
    fprintf('Training rate: %.4f\n\n',trainRate(i,iter));
    fprintf('Test set: %d\n',test_sid);
    fprintf('Test rate: %.4f\n\n',testRate(i,iter));
    fprintf('******************************\n\n')
    
    diary off
    
  end
  
  
  [confmat, prec, recall, fscore] = prec_recall(GT,PRED);
  
  results.meanTrain = mean(trainRate);
  results.stdTrain = std(trainRate);
  results.meanTest = mean(testRate);
  results.stdTest = std(testRate);
  
  results.meanPrec = mean(prec);
  results.stdPrec = std(prec);
  results.meanRecall = mean(recall);
  results.stdRecall = std(recall);
  results.meanFscore = mean(fscore);
  results.stdFscore = std(fscore);
  
  fprintf('******************************\n')
  fprintf('Mean Test rate: %.4f\n',mean(testRate));
  fprintf('Mean Test precision: %.4f\n',mean(prec));
  fprintf('Mean Test recall: %.4f\n',mean(recall));
  fprintf('Mean Test Fscore: %.4f\n',mean(fscore));
  fprintf('******************************\n\n')
  
  if save_on
    save(sprintf([filebase,'.mat'],iter),...
      'trainRate','testRate','results','prec','recall','fscore','confmat');
  end
  
end
