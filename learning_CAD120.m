function model = learning_CAD120(trainData,numStateZ,learning_option,log_on,thres)

DimX = trainData.DimX;
numStateY = 10;

params = init_params(trainData, DimX, numStateY, numStateZ);

if log_on
    timeStr = getTimeStr(now);
    make_log(timeStr); % LOG file and SAVE MODEL
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