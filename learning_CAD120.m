function [model,params] = learning_CAD120(trainData,numStateZ,learning_option,thres)
% iterate until convergence

DimX = trainData.DimX;

numStateY = 10;

params = init_params(trainData, DimX, numStateY, numStateZ);

% tic

model = [];

while true
    
    % Structured-SVM
    [params,model] = ssvm_learning(params,trainData,learning_option,model); 
    
    % stop iteration
    if abs(params.cumErrorPrev - params.cumError) < thres || params.numStateZ == 1
        break
    end    
    
    params.cumErrorPrev = params.cumError;
    
end