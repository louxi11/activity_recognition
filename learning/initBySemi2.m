function labels = initBySemi2(trainData,params)
% labels is a cell array
% semi supervised learning

X = trainData.patterns;
Y = trainData.labels;
XX = cell(size(trainData.patterns));
YY = cell(size(trainData.patterns));

dim = trainData.DimX;

% init missing target labels (Y==nan)
for i = 1 : length(trainData.patterns)
  x = X{i};
  y = Y{i};
  K = length(x) / dim;
  x = reshape(x,dim,K);
  XX{i} = x;

  % init y with left and right neighbors
  y = initFromNeighbor(y,params);
  % y(isnan(y)) = randsample(params.numStateY,sum(isnan(y)),true); % randomly initialize y

  YY{i} = y';
end

NUM = cellfun(@length,YY);
XX = [XX{:}]';
YY = [YY{:}]';

% init latent variables Z
opts = statset('UseParallel','always');
if params.numStateZ > 1
  IDX = kmeans(XX,params.numStateZ,'Replicates',10,...
    'emptyaction','singleton',...
    'Options',opts); % TODO
  % data is complete, compute joint state YZ
  YZ = sub2indYZ(params,YY,IDX);
else
  YZ = YY;
end

% split labels into videos
labels = mat2cell(YZ,NUM);

end
