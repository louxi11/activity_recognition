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

%%% SETTINGS
% -c C
% -p L-norm to use for slack variables
% -w optimization option1
% -o 2 rescaling method Margin rescaling
trainRate = zeros(4,1);
testRate = zeros(4,1);

%
C = 1;
E = 1.5;
W = 3;
numStateZ = 1;
tfeat = 'tfeat_on';
thres = 1; % threshold to stop iteration TODO

combos = combntns(1:4,3);

for i = 1 : size(combos,1)
  
  timeStr = getTimeStr(now);
  
  % select video for training set
  train_idx = combos(i,:);
  
  % load structured svm options
  learning_option = sprintf('-c %f -e %f -w %d',C,E,W); % ssvm learning parameters
  
  % split training and test data
  [trainData,testData] = load_CAD120('parse_off',tfeat,train_idx);
  
  % learning
  [model,params] = learning_CAD120(trainData,numStateZ,learning_option,log_on,thres,timeStr);
  
  % save model to file
  if save_on
    save(['model_',timeStr,'.mat'],'model','params','C','E','W','numStateZ','train_idx','tfeat','thres','trainData','testData')
  end
  
  diary off

end

%%
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