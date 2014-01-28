function [model,params] = learning_CAD120(trainData,numStateZ,learning_option,thres,initStrategy,C,model,partialLabelFlag,hasLatent)
% iterate until convergence

DimX = trainData.DimX;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% THIS CONSTANT DEFINES THE TOTAL NUMBER OF ACTIVITIES
% CHANGE THIS VALUE IF USING OTHER DATASET
numStateY = 10;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

params = init_params(trainData, DimX, numStateY, numStateZ,initStrategy);
params.trainData = trainData;
params.partialLabelFlag = partialLabelFlag;

% tic

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
    
%     cooling_eps = -decrement*0.01;
%     cooling_eps = max(cooling_eps, 0.5 * thres); 
%     if params.numStateZ == 1 % linear chain CRF
%       break
%     if decrement < thres && cooling_eps < 0.5*thres+1E-8
%       break
%     end
    
    if decrement < thres || ~hasLatent
      break
    end
      
    params.cnt = params.cnt + 1;
    
    params.cumErrorPrev = params.cumError;
    
    
end