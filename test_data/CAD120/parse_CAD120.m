function parse_CAD120(path)
% PARSE_CAD120  parse binary features of the CAD120 dataset
%   PARSE_CAD120(path) load both the segment-based features and temporal
%   features. path specifies the folder where to find the list of filenames
%   of the binary features

vidfiles = dir(fullfile(path,'*.txt')); % activity segments

video = cell(length(vidfiles),1);

num_objects = 5; % TODO: USE CLASS OF OBJECTS INSTEAD

for v = 1 : length(vidfiles)
    
    vidfile = fullfile(path,vidfiles(v).name);
    
    % parse video file into segments
    disp(vidfile)
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

save(fullfile(path,'CAD120video.mat'),'video')


%%% CONVERT TO FORMAT OF STRUCTUED-SVM
load(fullfile(path,'CAD120video.mat'));
FEATURES = {'obj' 'skel' 'interobj' 'skelobj'};
TEMPORAL_FEATURES = {'obj' 'skel' 'interobj' 'skelobj' 'temporalObj' 'temporalSkel'};


% single segment features
X = cell(length(video),1);
Y = cell(length(video),1);
A = cell(length(video),1);
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
        A{v} = [A{v},encodeAffordance(seg.affordance,12)];
    end
end

FEATURE_LENGTH = numel(F);


% combined temporal features
Xt = cell(length(video),1);
Yt = cell(length(video),1);
At = cell(length(video),1);
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
        At{v} = [At{v},encodeAffordance(seg.affordance,12)];
    end
end
mask = ~cellfun('isempty',Xt);
Xt = Xt(mask); % remove empty cell in X
Yt = Yt(mask); % remove empty cell in labels
At = At(mask);
TEMPORAL_FEATURE_LENGTH = numel(F);
vid_id_t = vid_id(mask);
save(fullfile(path,'CAD120.mat'),'X','Y','A','Xt','Yt','At','FEATURE_LENGTH','TEMPORAL_FEATURE_LENGTH','vid_id','vid_id_t');

fprintf('Data saved to %s.\n\n',fullfile(path,'CAD120.mat'))

