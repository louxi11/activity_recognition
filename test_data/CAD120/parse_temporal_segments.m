function data = parse_temporal_segments(data, segpath, num_objects)
% PARSE_SEGMENTS parses one segment of the video data in the CAD120 dataset
% num_objects is the total number of objects in the video
% segpath is the data file of one video segment

% open one segment file
fid = fopen(segpath);


% Parse meta data
s = textscan(fid,'%f',4);
s = s{1};
E3 = s(1);  % number of temporal object-object edges
E4 = s(2);  % number of temporal skeleton-skeleton edges
SN1 = s(3);  % segment number 1
SN2 = s(4);  % segment number 2

assert(data(SN1).N1 == E3)
assert(data(SN2).N1 == E3)
assert(E4 == 1)
assert(SN2 - SN1 == 1)


% Parse temporal object features (N1 x 40)
num_obj_features = 40;
data(SN2).features.temporalObj = zeros(num_obj_features,num_objects);
for o = 1 : E3
    s = textscan(fid,'%f',3);
    s = s{1};
    affordance_class1 = s(1);
    affordance_class2 = s(2);
    obj_id = s(3);
    assert(ismember(obj_id,find(data(SN1).object_id)))
    assert(ismember(obj_id,find(data(SN2).object_id)))
    assert(affordance_class1 == data(SN1).affordance(obj_id))
    assert(affordance_class2 == data(SN2).affordance(obj_id))
    
    s = textscan(fid,'%f:%f',num_obj_features);
    data(SN2).features.temporalObj(:,obj_id) = s{2};
end


% parse temporal skeleton features (1 x 160)
num_skeleton_features = 160;
data(SN2).features.temporalSkel = nan(num_skeleton_features,1);

s = textscan(fid,'%f',3);
s = s{1};

sub_activity1 = s(1);
sub_activity2 = s(2);
skel_id = s(3);

assert(sub_activity1 == data(SN1).sub_activity)
assert(sub_activity2 == data(SN2).sub_activity)
assert(skel_id == data(SN1).skel_id)
assert(skel_id == data(SN2).skel_id)


s = textscan(fid,'%f:%f',num_skeleton_features);
data(SN2).features.temporalSkel = s{2};


% check if parse has complete
while ~feof(fid)
    if ~isempty(fgetl(fid))
        error('parse_segments:ParseFile','Parse not complete')
    end
end

fclose(fid);

end