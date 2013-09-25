function data = corruptLabels(data,percentage)

labels = data.labels;

for i = 1 : length(data.labels)
  label = labels{i};
  len = length(label);
  idx = randsample(len,floor(len*percentage));
  label(idx) = nan;
  data.labels{i} = label;
end

end