function labels = initBySemi(trainData,params)
% labels is a cell array
% semi supervised learning

X = trainData.patterns;
Y = trainData.labels;
XX = cell(size(trainData.patterns));
YY = cell(size(trainData.patterns));

dim = trainData.DimX;

% init missing target labels (Y==nan)
if ~params.partialLabelFlag
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
end

NUM = cellfun(@length,YY);
XX = [XX{:}]';
YY = [YY{:}]';

% init latent variables Z
YZ = zeros(size(YY));
% opts = statset('UseParallel','true');
if params.numStateZ > 1
  for yidx = 1 : params.numStateY
    mask = YY == yidx;
    IDX = kmeans(XX(mask,:),params.numStateZ,'Replicates',10,...
      'emptyaction','singleton'); % TODO
    % data is complete, compute joint state YZ
    YZ(mask) = sub2indYZ(params,YY(mask),IDX);
  end
else
  YZ = YY;
end

% split labels into videos
labels = mat2cell(YZ,NUM);

end