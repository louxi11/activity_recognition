function [trainData,testData] = load_CAD120(tfeat,train_sid,path)
% LOAD_CAD120 is a interface function that converts the CAD-120 dataset
% If you want to use a new dataset, customize it to your own function. The
% output of the function needs to keep the same format.
%
% Description of the output structure:
%
%     Data.patterns: input features
%
%     Data.labels: output labels (activitie sequence)
%
%     Data.DimX: Dimensionality of the input features
%
%     Data.Affordance: affordance labels (not necessary for other dataset)
%
%     Data.HighLabels: high-level activity labels (not necessary for other dataset)
%
%     Data.occlusion_features: global input features (not necessary for other dataset)
%
%     Data.vidID: identity of the data object
%
%



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
%     cd ../../
    
    train_videos = [subjects{train_sid}];
    train_videos = train_videos(:);
    test_videos = [subjects{test_sid}];
    test_videos = test_videos(:);
    
    [~,trainidx,~] = intersect(vid_id,train_videos);
    [~,testidx,~] = intersect(vid_id,test_videos);
    
    % high level activities
    train_hid = vid_id(trainidx);
    [~,train_hidx] = ismember(train_hid,Yhigh.vidID);
    test_hid = vid_id(testidx);
    [~,test_hidx] = ismember(test_hid,Yhigh.vidID);
    
    % occlusion features
    [~,trainidxOF,~] = intersect(occlusion_features.vidID,train_videos);
    [~,testidxOF,~] = intersect(occlusion_features.vidID,test_videos);
    assert(length(trainidxOF) == length(train_videos));
    assert(length(testidxOF) == length(test_videos));
    
    % make sure no intersection between training and test set
    assert(isempty(intersect(trainidx,testidx)))
end


% load final training set
trainData.patterns = X(trainidx);
trainData.labels = Y(trainidx);
trainData.DimX = FEATURE_LENGTH;
trainData.Affordance = A(trainidx);
trainData.HighLabels = Yhigh.labels(train_hidx);
trainData.occlusion_features = occlusion_features.features(trainidxOF,:);
trainData.vidID = train_hid;

% load final test set
testData.patterns = X(testidx);
testData.labels = Y(testidx);
testData.DimX = FEATURE_LENGTH;
testData.HighLabels = Yhigh.labels(test_hidx);
testData.occlusion_features = occlusion_features.features(testidxOF,:);
testData.vidID = test_hid;

end