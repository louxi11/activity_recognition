dest = 'CAD120/segmentation_lists';

addpath graphical_model/
addpath inference/
addpath learning
addpath svm-struct-matlab-1.2/
addpath tools/
addpath evaluation/

addpath test_data/
addpath test_data/CAD120/

d = dir(dest);
d = d(3:end);
isub = [d(:).isdir];
df = {d(isub).name};

c = pwd;
for i = 1 : length(df)
  parse_CAD120(fullfile(pwd,dest,df{i}));
end