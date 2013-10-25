function [trainData,testData] = load_CAD120(tfeat,train_sid,path)

tfeat_opts = {'tfeat_on','tfeat_off'};

% validate input arguments
if ~sum(strcmp(tfeat,tfeat_opts))
    error('load_CAD120:invalid input argument:','tfeat should be either "tfeat_on" or "tfeat_off"');
end

% if exist()
load(fullfile(path,'CAD120.mat'));

% replace data with tfeatures if the switch is turned on
if strcmp(tfeat,'tfeat_on') 
    X = Xt;
    Y = Yt;
    vid_id = int32(str2double(vid_id_t));
    FEATURE_LENGTH = TEMPORAL_FEATURE_LENGTH;
    A = At;
else
    vid_id = int32(str2double(vid_id));
end


% split training and test set based on subject id
if isempty(train_sid)
    warning('using default train_sid,');
    trainidx = 1:110; % default
    testidx = 111:125;
else
    all_sid = 1 : 4;
    test_sid = all_sid(~ismember(all_sid,train_sid));
    
%     cd test_data/CAD120/
    subjects = parse_subject(fullfile(pwd,'CAD120'));
%     cd ../../
    
    train_videos = [subjects{train_sid}];
    train_videos = train_videos(:);
    test_videos = [subjects{test_sid}];
    test_videos = test_videos(:);
    
    [~,trainidx,~] = intersect(vid_id,train_videos);
    [~,testidx,~] = intersect(vid_id,test_videos);
    
    % make sure no intersection between training and test set
    assert(isempty(intersect(trainidx,testidx)))
end


% load final training set and test set
trainData.patterns = X(trainidx);
trainData.labels = Y(trainidx);
trainData.DimX = FEATURE_LENGTH;
trainData.Affordance = A(trainidx);
testData.patterns = X(testidx);
testData.labels = Y(testidx);
testData.DimX = FEATURE_LENGTH;

end