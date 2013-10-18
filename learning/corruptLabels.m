function data = corruptLabels(data,percentage)

labels = data.labels;

if percentage ~= inf
  for i = 1 : length(data.labels)
    label = labels{i};
    len = length(label);
    idx = randsample(len,floor(len*percentage));
    label(idx) = nan;
    data.labels{i} = label;
  end
else
  % make transition nodes to nan
  for i = 1 : length(data.labels)
    label = labels{i};
    c = SplitVec(label);
    len = cellfun('length',c);
    cumlen = cumsum(len);
    mask = len >= 5;
    mask(end) = 0; % make sure not the end label is chozen
    idx = cumlen(mask);
    label(idx) = nan;
    data.labels{i} = label;
  end
end

end