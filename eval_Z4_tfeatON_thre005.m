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
rate = zeros(4,1);
% GP = cell(4,1);

combos = combntns(1:4,3);
model = [];
for i = 1 : size(combos,1)
  
  train_idx = combos(i,:);
  
  C = 1;
  E = 0.05;
  W = 3;
  numStateZ = 4;
  tfeat = 'tfeat_on';
  thres = 0.05; % threshold to stop iteration TODO
  timeStr = getTimeStr(now);
  
  learning_option = sprintf('-c %f -e %f -w %d',C,E,W); % ssvm learning parameters
  [trainData,testData] = load_CAD120('parse_off',tfeat,train_idx);
  [model,params] = learning_CAD120(trainData,numStateZ,learning_option,log_on,thres,model);
  
  % save model to file
  if save_on
    save(['model_',timeStr,'.mat'],'model','params','C','E','W','numStateZ','train_idx','tfeat','thres')
  end

  %% Classification
  % load charRecognitionSmall
  % load test_data/model_WordRecognition
  
  CNT = 0;
  D = 0;
  data = testData;
  for j = 1 : length(data.patterns)
    X_test = data.patterns{j};
    yhat = ssvm_classify(params, model, X_test);
    disp([data.labels{j}';yhat'])
    D = D + sum( int32(data.labels{j}) == int32(yhat));
    CNT = CNT + length(data.labels{j});
  end
  rate(i) = D/CNT;
end
