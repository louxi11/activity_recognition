function data = flipLabels(data,flipProp)

labels = data.labels;

% set transition nodes to nan
for i = 1 : length(data.labels)
  label = labels{i};
  tLabels = find(diff(label)); % transition labels
  tIdx = randsample([true,false],length(tLabels),true,[flipProp,1-flipProp]); % random sampled positions
  fLabels = tLabels(tIdx);
  label(fLabels) = label(fLabels + 1);
  data.labels{i} = label;
end

end