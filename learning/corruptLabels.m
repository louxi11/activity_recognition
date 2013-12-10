function data = corruptLabels(data,percentage,nanProp)

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
  % set transition nodes to nan
  for i = 1 : length(data.labels)
    label = labels{i};
    tLabels = find(diff(label)); % transition labels
    tIdx = randsample([true,false],length(tLabels),true,[nanProp,1-nanProp]); % random sampled positions
    fLabels = tLabels(tIdx);
    label(fLabels) = nan;
    data.labels{i} = label;
  end
end

end