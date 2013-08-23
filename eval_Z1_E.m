clc
clear all

addpath graphical_model/
addpath inference/
addpath learning
addpath svm-struct-matlab-1.2/
addpath tools/

addpath test_data/

save_on = 1;

%%% parameters %%%
numStateZ = 1;
C = 1; % normalization constant
eval_set = [0.05, 0.25, 0.5, 0.75, 1.5, 2, 3, 4];
initByClustering = true;

%%% allocate buffer %%%
trainRate = zeros(4,length(eval_set));
testRate = zeros(4,length(eval_set));

for iter = 1 : length(eval_set) % epsilon
  
  E = eval_set(iter);
  
  W = 3; % optimization strategy
  tfeat = 'tfeat_on';
  thres = 1; % threshold to stop iteration TODO
  
  P = 1; % L-norm of slack. Use 1 for L1 and 2 for e^2
  
  combos = combntns(1:4,3);

  %%% learning %%%
  for i = 1 : size(combos,1)
    
    % select video for training set
    train_sid = combos(i,:);
    all_sid = 1 : 4;
    test_sid = all_sid(~ismember(all_sid,train_sid));
    
    if save_on
      logfile = sprintf('Z%d_C%d_E%.2f_W%d_%s_Thre%.1f_Test%d',numStateZ,C,E,W,tfeat,thres,test_sid);
      make_log(logfile); % LOG file and SAVE MODEL
    end
    
    % load structured svm options
    learning_option = sprintf('-c %f -e %f -w %d',C,E,W); % ssvm learning parameters
    
    % split training and test data
    [trainData,testData] = load_CAD120('parse_off',tfeat,train_sid);
    
    % learning
    [model,params] = learning_CAD120(trainData,numStateZ,learning_option,thres,initByClustering);

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
  
end

results.meanTrain = mean(trainRate);
results.meanTest = mean(testRate);
results.stdTrain = std(trainRate);
results.stdTest = std(testRate);
if save_on
  save(sprintf('%f.mat',mfilename),'trainRate','testRate','results');
end
