%% set path_to_file

%% load CAD120 data

clear all

videos = dir('segments_svm_format/*.txt'); % activity segments

data = repmat(struct('features',[],'sub_activities',[]), length(videos), 1);

%%

i = 1;

% parse video
vidfile = fullfile('segments_svm_format/',videos(i).name);

[sfile,tfile] = parse_video(vidfile);

% parse video to segments
j = 1;


% data(i)

% 'obj', [], 'human', [], ...
%     'obj_obj', [], 'obj_human', [], ...
%     'temporal_obj_obj', [], 'temporal_obj_human', [],

