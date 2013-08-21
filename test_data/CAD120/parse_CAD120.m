% % LOAD CAD120 DATASET TO MATLAB
% 
% clear all
% 
% vidfiles = dir('segments_svm_format/*.txt'); % activity segments
% 
% video = cell(length(vidfiles),1);
% 
% num_objects = 5; % TODO: USE CLASS OF OBJECTS INSTEAD
% 
% for v = 1 : length(vidfiles)
%     
%     vidfile = fullfile('segments_svm_format/',vidfiles(v).name);
%     
%     % parse video file into segments
%     [sfile,tfile] = parse_video(vidfile);
%     
%     data = repmat(struct('features',[],'N1',[],'E1',[],'E2',[],...
%         'K1',[],'K2',[],'FN',[],'sub_activity',[],...
%         'object_id',[],'skel_id',[],'affordance',[],...
%         'filename',[]), length(sfile), 1);
%     
%     % parse features in one segment
%     for s = 1 : length(sfile)  
%         data(s) = parse_segments(sfile{s},num_objects);
%     end
%     
%     % parse features between consecutive segments
%     for s = 1 : length(tfile)
%         data = parse_temporal_segments(data, tfile{s}, num_objects);
%     end
% 
%     video{v} = data;
%     
% end
% 
% sz = whos('video');
% 
% sz = sz.bytes/1024/1024;
% 
% fprintf('\nCAD120 loaded successfully. Total size = %.2fMB\n',sz);
% 
% save('CAD120video.mat','video')


%% CONVERT TO FORMAT OF STRUCTUED-SVM
load test_data/CAD120/CAD120video.mat
TEMP_FEAT = false; % TODO add temporal features
FEATURES = {'obj' 'skel' 'interobj' 'skelobj'};
TEMPORAL_FEATURES = {'obj' 'skel' 'interobj' 'skelobj' 'temporalObj' 'temporalSkel'};


% single segment features
X = cell(length(video),1);
Y = cell(length(video),1);
vid_id = cell(length(video),1);
for v = 1 : length(video)
    vid = video{v};
    vid_id{v} = vid(1).filename(1:end-6);
    for s = 1 : length(vid)
        seg = vid(s);
        F = [];
        for fn = 1 : length(FEATURES)
            f = seg.features.(FEATURES{fn});
            F = [F;f(:)];
        end
        Y{v} = [Y{v};seg.sub_activity];
        X{v} = [X{v};F];
    end
end

FEATURE_LENGTH = numel(F);


% combined temporal features
Xt = cell(length(video),1);
Yt = cell(length(video),1);
for v = 1 : length(video)
    vid = video{v};
    
    % skip video that has only two segments
    if length(vid) == 2
        continue 
    end
    
    % consider from the second frame since the first frame does not include
    % temporal features
    for s = 2 : length(vid)
        seg = vid(s);
        F = [];
        for fn = 1 : length(TEMPORAL_FEATURES)
            f = seg.features.(TEMPORAL_FEATURES{fn});
            F = [F;f(:)];
        end
        Yt{v} = [Yt{v};seg.sub_activity];
        Xt{v} = [Xt{v};F];
    end
end
mask = ~cellfun('isempty',Xt);
Xt = Xt(mask); % remove empty cell in X
Yt = Yt(mask); % remove empty cell in labels
TEMPORAL_FEATURE_LENGTH = numel(F);
vid_id_t = vid_id(mask);
save('CAD120.mat','X','Y','Xt','Yt','FEATURE_LENGTH','TEMPORAL_FEATURE_LENGTH','vid_id','vid_id_t');

fprintf('LOADE DATASET CARD120... DONE.\n')

