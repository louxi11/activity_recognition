% clear all
set_global_path

segShift = 0;
segWidth = 20;
train_sid = [2,1,3];
params.numStateZ = 4;
baseFile = 'uniform_20_0';

params.numStateY = 10;
params.partialLabelFlag = 0;
params.szYZ = [params.numStateY, params.numStateZ];
set_global_path;

baseFolder = fullfile(pwd,'CAD120/segmentation_lists');
path = fullfile(baseFolder,baseFile);
[data,~] = load_CAD120('tfeat_on',train_sid,path);


%%
load('/home/ninghang/workspace/activity_recognition/results_prob0_Z4_visualZ/opt_corrupt_Prob_0.00_uniform_20_0_C0.30_E0.40_W3_tfeat_on_Thre1.0_learning/model_uniform_20_0_Z4_C0.30_E0.40_W3_tfeat_on_Thre1.0_learning_iter1_Test4.mat')



% labels = initBySemi(data,params);
% labels = initBySemi2(data,params);

%%

close all

pred_labels = cell(size(data.patterns)); % predicted labels
pred_Zlabels = cell(size(data.patterns)); % predicted labels
for j = 1 : length(data.patterns)
  %   [yhat,zhat] = ind2subYZ(params,labels{j});
  [yhat,zhat] = ssvm_classify(params,model,data.patterns{j});
  pred_labels{j} = yhat';
  pred_Zlabels{j} = zhat';
end

%%

close all
% actIND = [1,3,4,6,7,8];
actIND = 1:10;
frameLists = cell(10,4);
% activityID = 6;
% ha = tight_subplot(params.numStateZ,length(actIND),[0.06 0],[0.01 0.05],[0.01 0.01]);
cnt = zeros(params.numStateZ,length(actIND));
for v = 1 : length(data.vidID)
  
  vid = data.vidID(v);
  gtlabels = data.labels{v};
  y = pred_labels{v};
  z = pred_Zlabels{v};
  
  % load color images
  imDir = '/media/Hitachi/CAD120/rgbd_images';
  
  svid = sprintf('%010d',vid);
  %   if ~strcmp(svid(1:2),'05')
  %     continue
  %   end
  
  cmd = sprintf('ls -v %s/Subject*/*/%s/RGB*.png',imDir,svid);
  [r,str] = system(cmd);
  assert(r == 0)
  images = textscan(str,'%s');
  images = images{1};
  
  % sample image frames based on segmentation method
  sampledFrame = images(segShift + round(segWidth / 2) : segWidth : end);
  
  % activity string for uniform segmentation
  strLabels = {'reaching', 'moving', 'pouring', 'eating', 'drinking', 'opening', 'placing', 'closing', 'null', 'scrubbing'};
  
  
  for i = 1 : length(y)
    frameLists{y(i),z(i)}{end+1} = sampledFrame(i);
  end
  
%   for i = 1 : length(y)
%     rw = find(actIND == y(i));
%     if rw > 0 & y(i) == gtlabels(i)
%       axes(ha(rw + (z(i) - 1) * length(actIND)));
%       imshow(sampledFrame{i})
%       axis tight
%       title([strLabels{y(i)},', comp.',num2str(z(i))], 'FontName','Times','FontSize', 14)
%       cnt(z(i),rw) = 1;
%       drawnow
%       if sum(cnt(:)) == numel(cnt)
%         waitforbuttonpress
%       end
%       %       cnt(y(i),z(i)) = cnt(y(i),z(i)) + 1;
%       pause(0.1)
%       %       waitforbuttonpress
%     end
%   end
  
end

disp('=====')

%% show images
close all
aid = 1;
zid = 1;
aSet = [1,3,4,6,7,8];
f = 1;

fig = figure('units','normalized','outerposition',[0 0 1 1]);
ha = tight_subplot(params.numStateZ,length(aSet),[0.06 0],[0.01 0.05],[0.01 0.01]);

writerObj = VideoWriter('peaks.avi');
writerObj.FrameRate = 2;
open(writerObj);

while f < 100
  for zid = 1 : params.numStateZ
    for a = 1 : length(aSet)
      aid = aSet(a);
      if f <= length(frameLists{aid,zid})
        aid = aSet(a);
        axes(ha(a + (zid - 1) * length(aSet)));
        imshow(frameLists{aid,zid}{f}{1})
        axis tight
        title([strLabels{aid},', comp.',num2str(zid)], 'FontName','Times','FontSize', 14)
        %       aid = aSet(a);
        %       subplot(4,length(aSet),(zid-1)*length(aSet)+a)
        %       imshow(frameLists{aid,zid}{f}{1})
        %       title([strLabels{aid},' ',num2str(zid)])
        drawnow
      end
    end
  end
%   pause(0.5)
  writeVideo(writerObj,getframe(fig));
%   waitforbuttonpress
  f = f + 1;
end
close(writerObj);

%%
