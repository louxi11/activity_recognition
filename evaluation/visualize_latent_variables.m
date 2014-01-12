
segShift = 0;
segWidth = 20;
v = 90;

baseFile = 'uniform_20_0';
baseFolder = fullfile(pwd,'CAD120/segmentation_lists');
path = fullfile(baseFolder,baseFile);
[trainData,testData] = load_CAD120('tfeat_on',train_sid,path);

data = trainData;
vid = data.vidID(v);
labels = data.labels{v};
numSegments = length(labels);

%%
imDir = '~/Downloads';
cmd = sprintf('ls -v %s/Subject*/*/%010d/RGB*.png',imDir,vid);
[~,str] = system(cmd);
images = textscan(str,'%s');
images = images{1};
len = length(images);

sampledFrame = images(segShift + round(segWidth / 2) : segWidth : end);
sampledFrame{end+1} = images{end};

% activity string for uniform segmentation
strLabels = {'reaching', 'moving', 'pouring', 'eating', 'drinking', 'opening', 'placing', 'closing', 'null', 'scrubbing'};

numSegments 
length(sampledFrame)

for i = 1 : length(labels)
  
  imshow(sampledFrame{i})
  title(strLabels{labels(i)})
  drawnow
  waitforbuttonpress
  
end



