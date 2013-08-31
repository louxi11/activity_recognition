function [model,params] = learning_CAD120(trainData,numStateZ,learning_option,thres,initStrategy,C)
% iterate until convergence

DimX = trainData.DimX;

numStateY = 10;

params = init_params(trainData, DimX, numStateY, numStateZ,initStrategy);

% tic

model = [];
cooling_eps = 0.5 * thres;
while true
    
    % Structured-SVM
    [params,model] = ssvm_learning(params,trainData,learning_option,model,C);   
    
    fprintf('******************************\n')
    fprintf('iteration = %d\n',params.cnt)
    fprintf('cumError = %f\n',params.cumError)
    fprintf('cumErrorPrev = %f\n',params.cumErrorPrev)
    fprintf('error reduction = %f\n', params.cumErrorPrev - params.cumError);
    % fprintf('time elapsed = %f\n', elapsedTime);
    fprintf('******************************\n')
    
    % stop iteration -TODO sometimes decrement < 0!!!!!
    decrement = params.cumErrorPrev - params.cumError;
    if params.numStateZ == 1 % linear chain CRF
      break
    elseif decrement < thres && cooling_eps < 0.5*thres+1E-8
      break
    else
      cooling_eps = -decrement*0.01;
      cooling_eps = max(cooling_eps, 0.5 * thres);
    end
      
    params.cnt = params.cnt + 1;
    
    params.cumErrorPrev = params.cumError;
    
    
end