
segShift = 0;
segWidth = 20;

baseFile = 'uniform_20_0';
baseFolder = fullfile(pwd,'CAD120/segmentation_lists');
path = fullfile(baseFolder,baseFile);
[trainData,testData] = load_CAD120('tfeat_on',train_sid,path);

data = trainData;

pred_labels = cell(size(data.patterns)); % predicted labels
pred_Zlabels = cell(size(data.patterns)); % predicted labels
X = data.patterns;
for j = 1 : length(data.patterns)
  x = X{j};
  [yhat,zhat] = ssvm_classify(params, model, x);
  pred_labels{j} = yhat';
  pred_Zlabels{j} = zhat';
  if sum(zhat' == 1) > 0
    disp('')
  end
end

%%

numImage = 10;
numStateZ = 2;
numSubAct = 10;

for v = 1 : length(data.vidID)
  % v = 28;
  
  vid = data.vidID(v);
  gtlabels = data.labels{v};
  labels = pred_labels{v};
  zlabels = pred_Zlabels{v};
  numSegments = length(labels);
  
  imDir = '~/Downloads';
  cmd = sprintf('ls -v %s/Subject*/*/%010d/RGB*.png',imDir,vid);
  [~,str] = system(cmd);
  images = textscan(str,'%s');
  images = images{1};
  len = length(images);
  
  sampledFrame = images(segShift + round(segWidth / 2) : segWidth : end);
  
  % activity string for uniform segmentation
  strLabels = {'reaching', 'moving', 'pouring', 'eating', 'drinking', 'opening', 'placing', 'closing', 'null', 'scrubbing'};
  
  s1 = 1;
  s2 = 1;
  actid = 10;
  sz = ones(numSubAct,numStateZ);
  for i = 1 : length(labels)
    if labels(i) == actid && zlabels(i) == 1 && s1 <= 5
      subplot(2,5,s1);
      imshow(sampledFrame{i})
      title([strLabels{labels(i)},' ',num2str(zlabels(i)),' ',strLabels{gtlabels(i)}])
      drawnow
      s1 = s1 + 1;
    elseif labels(i) == actid && zlabels(i) == 2 && s2 <= 5
      subplot(2,5,s2 + 5);
      imshow(sampledFrame{i})
      title([strLabels{labels(i)},' ',num2str(zlabels(i)),' ',strLabels{gtlabels(i)}])
      drawnow
      s2 = s2 + 1;
    end  
    
  end
  
end

disp('=====')


