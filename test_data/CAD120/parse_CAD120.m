% LOAD CAD120 DATASET TO MATLAB

clear all

vidfiles = dir('segments_svm_format/*.txt'); % activity segments

video = cell(length(vidfiles),1);

num_objects = 5; % TODO: USE CLASS OF OBJECTS INSTEAD

for v = 1 : length(vidfiles)
    
    vidfile = fullfile('segments_svm_format/',vidfiles(v).name);
    
    % parse video file into segments
    [sfile,tfile] = parse_video(vidfile);
    
    data = repmat(struct('features',[],'N1',[],'E1',[],'E2',[],...
        'K1',[],'K2',[],'FN',[],'sub_activity',[],...
        'object_id',[],'skel_id',[],'affordance',[],...
        'filename',[]), length(sfile), 1);
    
    % parse features in one segment
    for s = 1 : length(sfile)  
        data(s) = parse_segments(sfile{s},num_objects);
    end
    
    % parse features between consecutive segments
    for s = 1 : length(tfile)
        data = parse_temporal_segments(data, tfile{s}, num_objects);
    end

    video{v} = data;
    
end

sz = whos('video');

sz = sz.bytes/1024/1024;

fprintf('\nCAD120 loaded successfully. Total size = %.2fMB\n',sz);

save('CAD120video.mat','video')


%% CONVERT TO FORMAT OF STRUCTUED-SVM

TEMP_FEAT = false; % TODO add temporal features
FEATURES = {'obj' 'skel' 'interobj' 'skelobj'};
TEMPORAL_FEATURES = {'obj' 'skel' 'interobj' 'skelobj' 'temporal_obj' 'temporal_skel'};
FEATURE_LENGTH = 7530;

SKEL = [];
X = cell(length(video),1);
Y = cell(length(video),1);
for v = 1 : length(video)
    vid = video{v};
    for s = 1 : length(vid)
        seg = vid(s);
        SKEL = [SKEL,seg.skel_id];
        F = [];
        for fn = 1 : length(FEATURES)
            f = seg.features.(FEATURES{fn});
            F = [F;f(:)];
        end
        Y{v} = [Y{v};seg.sub_activity];
        X{v} = [X{v};F];
    end
end

save('CAD120.mat','X','Y');

fprintf('LOADE DATASET CARD120... DONE.\n')

