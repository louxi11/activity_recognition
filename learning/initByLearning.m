function  labels = initByLearning(trainData,params,model)

assert(~isempty(model))

labels = cell(trainData.patterns);
for k = 1 : length(trainData.patterns)
  X = trainData.patterns{k};
  Y = trainData.labels{k};
  [~,~,Yhat] = inferLatentVariable(params,model,X,Y);
  labels{k} = Yhat;
end

end