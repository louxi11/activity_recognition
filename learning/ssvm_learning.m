function [params,model] = ssvm_learning(params,trainData,learning_option,model,C)
% SSVM_LEARNING structured-SVM learning function
% params.patterns is the inputs X of the structured SVM, and params.labels
% is the Y which we would like to predict. params.patterns is a cell array where each
% cell contains a "column" vector which correpond to one sequence of
% observations. For exampel, assume X is a matrix (MxN). Then there are N
% time slices and each time slice has M dimensional data. params.patterns
% is computed as X(:); Using params.DimX, we can recover the X matrix back
% later

fprintf('-------------------------------\n');
fprintf('------ CCCP iteration %d ------\n',params.cnt);
fprintf('-------------------------------\n');

if params.need_init
  % random initialize latent variable Z TODO
  params.labels = cell(size(trainData.labels));
  if params.numStateZ == 1
    fprintf('Latent variable gets only one state. Equivilent to normal CRF.\n')
    params.labels = initBySemi(trainData,params);
  elseif strcmp(params.initStrategy,'random')
    fprintf('initilizing latent variables randomly\n')
    for i = 1 : length(params.patterns)
      Y = trainData.labels{i};
      Zhat = randsample(params.numStateZ,length(Y),true); % random sample with replacement
      YZ = sub2indYZ(params,Y,Zhat);
      params.labels{i} = YZ;
    end
  elseif strcmp(params.initStrategy,'clustering')
    fprintf('initilizing latent variables by clustering\n')
    params.labels = initByClustering(trainData,params);
  elseif strcmp(params.initStrategy,'semi')
    fprintf('initilizing latent variables by clustering (semi-supervised)\n')
    params.labels = initBySemi(trainData,params);  
  elseif strcmp(params.initStrategy,'affordance')
    fprintf('initilizing latent variables by Object Affordance\n')
    params.labels = initByAffordance(trainData,params);
  end
  params.need_init = false;
else
  % otherwise compute Zhat under the current model.w TODO
  for i = 1 : length(params.patterns)
    X = trainData.patterns{i};
    Y = trainData.labels{i};
    [Zhat,~,Yhat] = inferLatentVariable(params,model,X,Y);
    YZ = sub2indYZ(params,Yhat,Zhat);
    params.labels{i} = YZ;
  end
end

%---------------------- Structured SVM ----------------------------%
%%% update new model.w with (X,Y,Zhat) - STRUCTURED-SVM LEARNING
model = svm_struct_learn(learning_option, params);

% stop criteria - CCCP
params.cumError = cccp_error(params,trainData,model,C);

% % compute time so far
% elapsedTime = toc;

end