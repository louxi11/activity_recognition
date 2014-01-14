set_global_path

segShift = 0;
segWidth = 20;
train_sid = [1,2,3];
params.numStateZ = 2;
baseFile = 'uniform_20_0';

params.numStateY = 10;
params.szYZ = [params.numStateY, params.numStateZ];
set_global_path;

baseFolder = fullfile(pwd,'CAD120/segmentation_lists');
path = fullfile(baseFolder,baseFile);
[trainData,testData] = load_CAD120('tfeat_on',train_sid,path);


%%

labels = initBySemi(trainData,params);

% %%
% 
% X = trainData.patterns;
% Y = trainData.labels;
% XX = cell(size(trainData.patterns));
% YY = cell(size(trainData.patterns));
% 
% dim = trainData.DimX;
% 
% % init missing target labels (Y==nan)
% for i = 1 : length(trainData.patterns)
%   x = X{i};
%   y = Y{i};
%   K = length(x) / dim;
%   x = reshape(x,dim,K);
%   XX{i} = x;
% 
%   % init y with left and right neighbors
% %   y = initFromNeighbor(y,params);
%   % y(isnan(y)) = randsample(params.numStateY,sum(isnan(y)),true); % randomly initialize y
% 
%   YY{i} = y';
% end
% 
% NUM = cellfun(@length,YY);
% XX = [XX{:}]';
% YY = [YY{:}]';
% 
% % init latent variables Z
% opts = statset('UseParallel','always');
% if params.numStateZ > 1
%   IDX = kmeans(XX,params.numStateZ,'Replicates',10,...
%     'emptyaction','singleton',...
%     'Options',opts); % TODO
%   % data is complete, compute joint state YZ
%   YZ = sub2indYZ(params,YY,IDX);
% else
%   YZ = YY;
% end
% 
% % split labels into videos
% labels = mat2cell(YZ,NUM);

%%
data = trainData;
pred_labels = cell(size(data.patterns)); % predicted labels
pred_Zlabels = cell(size(data.patterns)); % predicted labels
X = data.patterns;
for j = 1 : length(data.patterns)
  x = X{j};
  [yhat,zhat] = ind2subYZ(params,labels{j});
  pred_labels{j} = yhat';
  pred_Zlabels{j} = zhat';
  if sum(zhat' == 1) > 0
    disp('')
  end
end

%%

numImage = 10;


actid = 1;

for v = 1 : length(data.vidID)
  % v = 28;
  
  vid = data.vidID(v);
  gtlabels = data.labels{v};
  labels = pred_labels{v};
  zlabels = pred_Zlabels{v};
  numSegments = length(labels);
  
  imDir = '/media/Hitachi/CAD120/rgbd_images';
  cmd = sprintf('ls -v %s/Subject*/*/%010d/RGB*.png',imDir,vid);
  [r,str] = system(cmd);
  if r > 0
    disp('no file exist')
    break
  end
  images = textscan(str,'%s');
  images = images{1};
  len = length(images);
  
  sampledFrame = images(segShift + round(segWidth / 2) : segWidth : end);
  
  % activity string for uniform segmentation
  strLabels = {'reaching', 'moving', 'pouring', 'eating', 'drinking', 'opening', 'placing', 'closing', 'null', 'scrubbing'};
  
  s1 = 1;
  s2 = 1;
  sz = ones(params.numStateY,params.numStateZ);
  for i = 1 : length(labels)
%     if zlabels(i) == 1 && s1 <= 5
%       subplot(2,5,s1);
%       imshow(sampledFrame{i})
%       title([strLabels{labels(i)},' ',num2str(zlabels(i)),' ',strLabels{gtlabels(i)}])
%       drawnow
%       s1 = s1 + 1;
    if zlabels(i) == 2 && s2 <= 5
      subplot(2,5,s2 + 5);
      imshow(sampledFrame{i})
      title([strLabels{labels(i)},' ',num2str(zlabels(i)),' ',strLabels{gtlabels(i)}])
      drawnow
      s2 = s2 + 1;
    end  
    
  end
  
end

disp('=====')


