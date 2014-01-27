function data = parse_segments(segpath,num_objects)
% PARSE_SEGMENTS parses one segment of the video data in the CAD120 dataset
% num_objects is the total number of objects in the video
% segpath is the data file of one video segment

% open one segment file
fid = fopen(segpath);


% Parse meta data
s = textscan(fid,'%f',6);
s = s{1};
N1 = s(1);  % number of object nodes
E1 = s(2);  % number of object object edges
E2 = s(3);  % number of skeleton object edges
K1 = s(4);  % total number of affordance classes
K2 = s(5);  % total number of sub-activity classes
FN = s(6);  % segment number

objects = nan(1,num_objects);
num_interobj_edges = nchoosek(num_objects,2) * 2;
affordance = nan(1,num_objects);

if N1 == 1
    assert(0 == E1)
else
    assert(nchoosek(N1,2) * 2 == E1) % interobject + inter-interobject distance
end
assert(N1 == E2)


% Parse object features (N1 x 180)
num_obj_features = 180;
data.features.obj = zeros(num_obj_features,num_objects);
for o = 1 : N1
    s = textscan(fid,'%f',2);
    s = s{1};
    affordance_class = s(1);
    obj_id = s(2);
    objects(obj_id) = 1;
    assert(ismember(obj_id,1 : num_objects))
    affordance(obj_id) = affordance_class;

    s = textscan(fid,'%f:%f',num_obj_features);
    data.features.obj(:,obj_id) = s{2};
end


% parse skeleton features (1 x 630)
num_skeleton_features = 630;
data.features.skel = nan(num_skeleton_features,1);

s = textscan(fid,'%f',2);
s = s{1};

sub_activity = s(1);
skel_id = s(2);

s = textscan(fid,'%f:%f',num_skeleton_features);
data.features.skel = s{2};
assert(sum(isnan(data.features.skel)) == 0)


% Parse inter-object features (E1 x 200)
num_interobj_features = 200;
data.features.interobj = zeros(num_interobj_features,num_interobj_edges);

if E1 ~= 0
    indice = combntns(1:N1,2);
    indice = [indice;fliplr(indice)];
    for e = 1 : E1

        s = textscan(fid,'%f',4);
        s = s{1};

        affordance1 = s(1);
        affordance2 = s(2);
        obj1_id = s(3);
        obj2_id = s(4);
        [temppp,interobj_idx] = ismember(indice,[obj1_id,obj2_id],'rows');

        assert(affordance(obj1_id) == affordance1)
        assert(affordance(obj2_id) == affordance2)
        assert(sum(interobj_idx) == 1)

        s = textscan(fid,'%f:%f',num_interobj_features);
        data.features.interobj(:,logical(interobj_idx)) = s{2};
    end
end


% Parse skeleton-object features (E2 * 400)
num_skelobj_features = 400;
data.features.skelobj = zeros(num_skelobj_features,num_objects);

for e = 1 : E2
    s = textscan(fid,'%f',3);
    s = s{1};

    affordance_class = s(1);
    obj_id = s(3);

    assert(affordance_class == affordance(obj_id))
    assert(sub_activity == s(2))

    s = textscan(fid,'%f:%f',num_skelobj_features);
    data.features.skelobj(:,obj_id) = s{2};
end


% check if parse has complete
while ~feof(fid)
    if ~isempty(fgetl(fid))
        error('parse_segments:ParseFile','Parse not complete')
    end
end

fclose(fid);

% load to data struct
data.N1 = N1;  % number of object nodes
data.E1 = E1;  % number of object object edges
data.E2 = E2;  % number of skeleton object edges
data.K1 = K1;  % total number of affordance classes
data.K2 = K2;  % total number of sub-activity classes
data.FN = FN;  % segment number
data.sub_activity = sub_activity;
data.object_id = objects;
data.skel_id = skel_id;
data.affordance = affordance;
[temp, filename, ext] = fileparts(segpath);
data.filename = [filename,ext];

end