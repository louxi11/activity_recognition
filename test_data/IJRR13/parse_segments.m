% function data = parse_segments(filepath)
clear all

filepath = '/home/ninghang/workspace/cornell/human_activity_labeling/features_cad120_ground_truth_segmentation/features_binary_svm_format/0126141638_1.txt';

% open segment file
fid = fopen(filepath);

% number of subsegments
s = textscan(fid,'%d',6);
s = s{1};
N1 = s(1);  % number of object nodes
E1 = s(2);  % number of object object edges
E2 = s(3);  % number of skeleton object edges
K1 = s(4);  % total number of affordance classes
K2 = s(5);  % total number of sub-activity classes
FN = s(6);  % segment number

% parse object node features
s = textscan(fid,'%d',2);
s = s{1};
obj_class = s(1);
obj_id = s(2);

s = textscan(fid,'%d:%d',180);
obj_features = s{2};


fclose(fid);
% get sub-segment feature filenames
% segs = textscan(fid,'%s');
% 
% assert(sum(s(1)) == length(segs(1)))
% assert(s(1)(1) == s(1)(2) + 1)
% 
% sfile = segs(1)(1:s(1)(1));
% 
% tfile = segs(1)(s(1)(1)+1:end);

% end