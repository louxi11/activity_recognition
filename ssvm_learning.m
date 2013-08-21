% function ssvm_learning

clc
clear all

addpath graphical_model/
addpath inference/
addpath learning
addpath svm-struct-matlab-1.2/
addpath tools/

addpath test_data/

% % dataset Word Recognition Large
% [trainData,testData] = load_word_recognition_data;
% DimX = 64;
% numStateY = 26;
% numStateZ = 1;

[trainData,testData] = load_CAD120('parse_off','tfeat_off',[1,2,3]);
DimX = trainData.DimX;
numStateY = 10;
numStateZ = 4;

% % dataset Word Recognition for testing factors PGM 7
% [trainData,testData] = load_word_recognition_data_factors;
% DimX = 64;
% numStateY = 26;
% numStateZ = 1;

% % dataset Word Recognition Small
% trainData = load_word_recognition_small_data;
% DimX = 16*8;
% numStateY = 26;
% numStateZ = 1;

% dataset for multiple class svm
% [patterns,labels] = load_example4_data;
% DimX = size(patterns{1},2);
% numStateY = 7;
% numStateZ = 1;

%% LEARNING
% param.patterns is a cell array of inputs X. Each cell X{i} corresponds with one
% observation sequence. The rows of one cell has MxN dimension, which means
% there are M observation (time slices) and for each time slice there is a
% N dimensional observation
% parm.labels is a cell array of output target Y. The structure of the cell
% is similar to X

thres = 1; % threshold to stop iteration
timeStr = getTimeStr(now);
tic
% log_on(timeStr); % LOG file and SAVE MODEL

% parameter settings
params = init_params(DimX, numStateY, numStateZ);
params.patterns = trainData.patterns;
params.dimension = params.idx_w_tran(end);
params.verbose = 0 ;
params.lossFn = @lossCB ;
params.constraintFn  = @constraintCB ;
params.featureFn = @featureCB ;

%%%
cumErrorPrev = inf;
need_init = true;
cnt = 0;

while true

    cnt = cnt + 1;
    fprintf('-------------------------------\n');
    fprintf('------ CCCP iteration %d ------\n',cnt);
    fprintf('-------------------------------\n');
    
    if need_init
        % initialize Hidden state Z TODO
        params.labels = cell(size(trainData.labels));
        if need_init
            for i = 1 : length(params.patterns)
                Y = trainData.labels{i};
                Zhat = randsample(params.numStateZ,length(Y),true); % random sample with replacement
                YZ = sub2indYZ(params,Y,Zhat);
                params.labels{i} = YZ;
                need_init = false;
            end
        end
    else
        % compute optimal Zhat under the current model.w
        for i = 1 : length(params.patterns)
            X = trainData.patterns{i};
            Y = trainData.labels{i};
            Zhat = inferLatentVariable(params,model,X,Y);
            YZ = sub2indYZ(params,Y,Zhat);
            params.labels{i} = YZ;
        end
    end
    
    %---------------------- Structured SVM ----------------------------%
    %%% update new model.w with (X,Y,Zhat) - STRUCTURED-SVM LEARNING
    %  svm_struct_learn is a function that calls three matlab functions
    %  1. lossCB: delta(y,yhat), it returns the number of misclassified labels
    %     of the sequence
    %  2. featureCB: psi(x,y;w) returns a feature vector which has the same
    %     size as the parameters vector w
    %  3. constraintCB: compute yhat = argmax_y(delta(y,yhat),psi(x,y;w))
    %     where psi(x,y;w) = <w,phi(x,y)>
    
    
    % -y verbose level on svm light
    % -v verbose leve on ssvm
    
    % -c C
    % -p L-norm to use for slack variables
    % -w optimization option1
    % -o 2 rescaling method Margin rescaling
    %  Estimate new model.w with complete data (X,YZ)
    ssvm_option = '-y 0 -v 1 -c 1 -e 0.05 -o 2 -w 3 -l 1';
    params.ssvm_option = ssvm_option;
    model = svm_struct_learn(ssvm_option, params);
    
    % stop criteria - CCCP
    cumError = cccp_error(params,trainData,model);
    
    elapsedTime = toc;
    
    fprintf('******************************\n')
    fprintf('iteration = %d\n',cnt)
    fprintf('cumError = %f\n',cumError)
    fprintf('cumErrorPrev = %f\n',cumErrorPrev)
    fprintf('error reduction = %f\n', cumErrorPrev - cumError);
    fprintf('time elapsed = %f\n', elapsedTime);
    fprintf('******************************\n')
      
    if abs(cumErrorPrev - cumError) < thres
        break
    end
    
    cumErrorPrev = cumError;
    startTime = endTime;
    
end

if strcmp(get(0,'diary'),'on')
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
