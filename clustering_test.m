clear all
load('model_Z1_C1_E0.05_W3_tfeat_on_Thre1.0_Test4.mat')

X = trainData.patterns;
Y = trainData.labels;
XX = [];
YY = [];
for i = 1 : length(trainData.patterns)
  x = X{i};
  y = Y{i};
  K = length(x) / trainData.DimX;
  x = reshape(x,trainData.DimX,K);
  XX = [XX,x];
  YY = [YY;y];
end
XX = XX';

%%
IDX = kmeans(XX,4);