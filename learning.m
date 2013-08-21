clc
% numStateZ == 1 : without latent variable
% numStateZ > 1 : numStateZ latent variable(s)

clear all

addpath graphical_model/
addpath inference/
addpath learning
addpath svm-struct-matlab-1.2/
addpath tools/

addpath test_data/

[trainData,testData] = load_CAD120('parse_off','tfeat_off',[1,2,3]);
DimX = trainData.DimX;
numStateY = 10;
numStateZ = 4;

% [trainData,testData,DimX,numStateY,numStateZ] = load_debug_dataset(1);

%% SETTINGS
% -c C
% -p L-norm to use for slack variables
% -w optimization option1
% -o 2 rescaling method Margin rescaling
learning_option = '-c 1 -e 0.05 -w 3'; % ssvm learning parameters
log_on = 0; % log switch
thres = 1; % threshold to stop iteration TODO

%% LEARNING

params = init_params(trainData, DimX, numStateY, numStateZ);

if log_on
    timeStr = getTimeStr(now);
    log_on(timeStr); % LOG file and SAVE MODEL
end

tic

while true
    % Structured-SVM
    [params,model] = ssvm_learning(params,trainData,learning_option); 
    
    % stop iteration
    if abs(params.cumErrorPrev - params.cumError) < thres || params.numStateZ == 1
        break
    end    
    
    cumErrorPrev = cumError;   
end

% save model to file
if log_on
    save(['model_',timeStr,'.mat'],'model','params')
    diary off
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
