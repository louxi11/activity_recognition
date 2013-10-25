function labels = initBySemi(trainData,params)
% labels is a cell array
% semi supervised learning

X = trainData.patterns;
Y = trainData.labels;
XX = cell(size(trainData.patterns));
YY = cell(size(trainData.patterns));

dim = trainData.DimX;
% init missing target labels (Y==nan)
parfor i = 1 : length(trainData.patterns)
  x = X{i};
  y = Y{i};
  K = length(x) / dim;
  x = reshape(x,dim,K);
  XX{i} = x;
  % y(isnan(y)) = randsample(params.numStateY,sum(isnan(y)),true); % randomly initialize y
  
  % init y with left and right neighbors
  if sum(isnan(y)) > 0
    y = initFromNeighbor(y,params); 
  end
  YY{i} = y';
end
NUM = cellfun(@length,YY);
XX = [XX{:}]';
YY = [YY{:}]';

% init latent variables Z
opts = statset('UseParallel','always');
IDX = kmeans(XX,params.numStateZ,'Replicates',10,...
  'distance','Hamming','emptyaction','singleton',...
  'Options',opts); % TODO

% data is complete, compute joint state YZ
YZ = sub2indYZ(params,YY,IDX);

% split labels into videos
labels = mat2cell(YZ,NUM);

end
