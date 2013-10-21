function [trainData,testData] = load_CAD120(parse,tfeat,train_sid,path)

parse_opts = {'parse_on','parse_off'};
tfeat_opts = {'tfeat_on','tfeat_off'};

% validate input arguments
if ~sum(strcmp(parse,parse_opts))
    error('load_CAD120:invalid input argument:','parse should be either "parse_on" or "parse_off"');
elseif ~sum(strcmp(tfeat,tfeat_opts))
    error('load_CAD120:invalid input argument:','tfeat should be either "tfeat_on" or "tfeat_off"');
end

if strcmp(parse,'parse_on')
    cd test_data/CAD120/
    parse_CAD120
    cd ../../
end

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
    
    cd test_data/CAD120/
    subjects = parse_subject;
    cd ../../
    
    train_videos = [subjects{train_sid}];
    train_videos = train_videos(:);
    test_videos = [subjects{test_sid}];
    test_videos = test_videos(:);
    
    [temp1,trainidx,temp2] = intersect(vid_id,train_videos);
    [temp1,testidx,temp2] = intersect(vid_id,test_videos);
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