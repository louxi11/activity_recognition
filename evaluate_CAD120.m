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
C = 1;
E = 0.05;
W = 3;
numStateZ = 1;
train_idx = [1,2,3];
tfeat = 'tfeat_off';
thres = 1; % threshold to stop iteration TODO
timeStr = getTimeStr(now);

learning_option = sprintf('-c %f -e %f -w %d',C,E,W); % ssvm learning parameters
[trainData,testData] = load_CAD120('parse_off',tfeat,train_idx);
[model,params] = learning_CAD120(trainData,numStateZ,learning_option,log_on,thres);

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
for i = 1 : length(data.patterns)
    X_test = data.patterns{i};
    yhat = ssvm_classify(params, model, X_test);
    disp([data.labels{i}';yhat'])
    D = D + sum( int32(data.labels{i}) == int32(yhat));
    CNT = CNT + length(data.labels{i});
end
disp(D/CNT)
