function [patterns,labels] = load_example4_data

numFeat = 53;
fid = fopen('test_data/example4/train.dat', 'rt');
data = textscan(fid,'%s','delimiter','\n');
data = data{1};

labels = cell(1,size(data,1));
patterns = cell(1,size(data,1));
for i = 1 : size(data,1)
  d = data{i};
  l = str2double(d(1)); 
  r = d(3:end);
  f = textscan(r, '%u%*1s%f', 'Delimiter', ' ');
  x = zeros(numFeat,1);
  x(f{1}) = f{2};
  patterns{i} = x';
  labels{i} = l;
end

end