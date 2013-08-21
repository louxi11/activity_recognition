function [params,cumError] = ssvm_learning(params,trainData)
% stuctured svm learning

if params.need_init
    % random initialize latent variable Z TODO
    params.labels = cell(size(trainData.labels));
    if params.need_init
        for i = 1 : length(params.patterns)
            Y = trainData.labels{i};
            Zhat = randsample(params.numStateZ,length(Y),true); % random sample with replacement
            YZ = sub2indYZ(params,Y,Zhat);
            params.labels{i} = YZ;
            params.need_init = false;
        end
    end
else
    % otherwise compute Zhat under the current model.w
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
model = svm_struct_learn(params.ssvm_option, params);

% stop criteria - CCCP
cumError = cccp_error(params,trainData,model);

% compute time so far
elapsedTime = toc;

fprintf('******************************\n')
fprintf('iteration = %d\n',cnt)
fprintf('cumError = %f\n',cumError)
fprintf('cumErrorPrev = %f\n',cumErrorPrev)
fprintf('error reduction = %f\n', cumErrorPrev - cumError);
fprintf('time elapsed = %f\n', elapsedTime);
fprintf('******************************\n')

end