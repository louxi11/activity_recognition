function labels = initBySemi2(trainData,params)
% labels is a cell array

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
  YY = mat2cell(YY,NUM);
  IDX = mat2cell(IDX,NUM);
  YZ = cell(size(YY));
  for i = 1 : length(YY)
    YZ{i} = [YY{i};IDX{i}];
  end
else
  YZ = mat2cell(YY,NUM); % use 1 when there is only one stateZ
end

% split labels into videos
labels = YZ;

end
