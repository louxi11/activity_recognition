function  labels = initByLearning(trainData,params,model)

assert(~isempty(model))

labels = cell(trainData.patterns);
for k = 1 : length(trainData.patterns)
  X = trainData.patterns{k};
  Y = trainData.labels{k};  
  [Zhat,~,Yhat] = inferLatentVariable(params,model,X,Y);
  YZhat = [Yhat;Zhat];
  labels{k} = YZhat; % TODO
end

end