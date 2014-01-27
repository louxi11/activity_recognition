dest = 'CAD120/segmentation_lists';

set_global_path;

d = dir(dest);
d = d(3:end);
isub = [d(:).isdir];
df = {d(isub).name};

c = pwd;
for i = 1 : length(df)
  parse_CAD120(fullfile(pwd,dest,df{i}));
end