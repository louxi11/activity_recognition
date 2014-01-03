function data = flipLabels(data,flipProb)

labels = data.labels;
data.nanIdx = cell(size(labels));

% set transition nodes to nan with probability flipProb
for i = 1 : length(data.labels)
  label = labels{i};
  tLabels = find(diff(label)); % transition labels
  tIdx = randsample([true,false],length(tLabels),true,[flipProb,1-flipProb]); % random sampled positions
  fLabels = tLabels(tIdx);
  label(fLabels) = label(fLabels + 1);
  data.labels{i} = label;
  data.nanIdx{i} = fLabels;
end

end