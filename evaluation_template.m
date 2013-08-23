clc
clear all

addpath graphical_model/
addpath inference/
addpath learning
addpath svm-struct-matlab-1.2/
addpath tools/

addpath test_data/

log_on = 0;
save_on = 1;


%%% allocate buffer %%%
trainRate = zeros(4,1);
testRate = zeros(4,1);

%%% parameters %%%
numStateZ = 1;
C = 1; % normalization constant
E = 2; % epsilon
W = 3; % optimization strategy
tfeat = 'tfeat_on';
thres = 1; % threshold to stop iteration TODO

P = 1; % L-norm of slack. Use 1 for L1 and 2 for e^2

combos = combntns(1:4,3);


%%% learning %%%

timeStr = getTimeStr(now);
if log_on
    make_log(timeStr); % LOG file and SAVE MODEL
end
  
for i = 1 : size(combos,1)

  % select video for training set
  train_idx = combos(i,:);
  
  % load structured svm options
  learning_option = sprintf('-c %f -e %f -w %d',C,E,W); % ssvm learning parameters
  
  % split training and test data
  [trainData,testData] = load_CAD120('parse_off',tfeat,train_idx);
  
  % learning
  [model,params] = learning_CAD120(trainData,numStateZ,learning_option,thres);
  
  % save model to file
  if save_on
    save(['model_',timeStr,'_',i,'.mat'],'model','params','C','E','W','numStateZ','train_idx','tfeat','thres','trainData','testData')
  end
  
  diary off
  

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
trainRate(i) = D/CNT;

CNT = 0;
D = 0;
data = testData;
for j = 1 : length(data.patterns)
  X_test = data.patterns{j};
  yhat = ssvm_classify(params, model, X_test);
  D = D + sum( int32(data.labels{j}) == int32(yhat));
  CNT = CNT + length(data.labels{j});
end
testRate(i) = D/CNT;

all_sid = 1 : 4;
test_sid = all_sid(~ismember(all_sid,train_idx));

fprintf('******************************\n')
fprintf('Training set: %d, %d, %d\n',train_idx(1),train_idx(2),train_idx(3));
fprintf('classification rate: %f\n',trainRate(i));
fprintf('Test set: %d\n',test_sid);
fprintf('classification rate: %f\n',testRate(i));

end
fprintf('******************************\n\n')