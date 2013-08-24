function [model,params] = learning_CAD120(trainData,numStateZ,learning_option,thres,initByClustering)
% iterate until convergence

DimX = trainData.DimX;

numStateY = 10;

params = init_params(trainData, DimX, numStateY, numStateZ,initByClustering);

% tic

model = [];

while true
    
    % Structured-SVM
    [params,model] = ssvm_learning(params,trainData,learning_option,model);   
    
    fprintf('******************************\n')
    fprintf('iteration = %d\n',params.cnt)
    fprintf('cumError = %f\n',params.cumError)
    fprintf('cumErrorPrev = %f\n',params.cumErrorPrev)
    fprintf('error reduction = %f\n', params.cumErrorPrev - params.cumError);
    % fprintf('time elapsed = %f\n', elapsedTime);
    fprintf('******************************\n')
    
    % stop iteration
    if abs(params.cumErrorPrev - params.cumError) < thres || params.numStateZ == 1
        break
    end  
      
    params.cnt = params.cnt + 1;
    
    params.cumErrorPrev = params.cumError;
    
    
end