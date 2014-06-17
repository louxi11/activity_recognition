function  labels = initByLearning(trainData,params,model)

assert(~isempty(model))

labels = cell(trainData.patterns);
for k = 1 : length(trainData.patterns)
  X = trainData.patterns{k};
  Y = trainData.labels{k};  
  [Zhat,~,Yhat] = inferLatentVariable(params,model,X,Y);
  
  if params.numStateZ > 1
    YZhat = [Yhat;Zhat];
  else
    YZhat = Yhat;
  end
  labels{k} = YZhat; % TODO
end

end