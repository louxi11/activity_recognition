
segShift = 0;
segWidth = 20;

v = 90;

data = trainData;

vid = data.vidID(v);
labels = data.labels{v};
numSegments = length(labels);

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



