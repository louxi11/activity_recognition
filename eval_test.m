function eval_test(Z,C,E,W,thres,initStrategy)

clc
% clear all

addpath graphical_model/
addpath inference/
addpath learning
addpath svm-struct-matlab-1.2/
addpath tools/

addpath test_data/

save_on = 1;

%%% parameters %%%
numStateZ = Z;
% C = 0.4; % normalization constant
% E = 0.5; % epsilon
% W = 3; % optimization strategy
tfeat = 'tfeat_on';
% thres = 1; % threshold to stop iteration TODO
% initByClustering = true;
P = 1; % L-norm of slack. Use 1 for L1 and 2 for e^2

iter = 1;
%%% allocate buffer %%%
trainRate = nan(4,1);
testRate = nan(4,1);



combos = combntns(1:4,3);

%%% learning %%%
for i = 1 : size(combos,1)
  
  % select video for training set
  train_sid = combos(i,:);
  all_sid = 1 : 4;
  test_sid = all_sid(~ismember(all_sid,train_sid));
  
  if save_on
    logfile = sprintf('Z%d_C%.2f_E%.2f_W%d_%s_Thre%.1f_clust%s_Test%d',...
      numStateZ,C,E,W,tfeat,thres,num2str(initStrategy),test_sid);
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
    D = D + sum( int32(data.labels{j}) == int32(yhat));
    CNT = CNT + length(data.labels{j});
  end
  testRate(i,iter) = D/CNT;

  fprintf('******************************\n')
  fprintf('Training set: %d, %d, %d\n',train_sid(1),train_sid(2),train_sid(3));
  fprintf('classification rate: %f\n',trainRate(i,iter));
  fprintf('Test set: %d\n',test_sid);
  fprintf('classification rate: %f\n',testRate(i,iter));
  fprintf('******************************\n\n')

  diary off
  
end

results.meanTrain = mean(trainRate);
results.meanTest = mean(testRate);
results.stdTrain = std(trainRate);
results.stdTest = std(testRate);
if save_on
  save(sprintf('Z%d_C%.2f_E%.2f_W%d_%s_Thre%.1f_%s.mat',numStateZ,C,E,W,tfeat,thres,initStrategy),'trainRate','testRate','results');
end
