function data = corruptLabels(data,nanProb)

labels = data.labels;
data.nanIdx = cell(size(labels));

% set transition nodes to nan with probability nanProb
for i = 1 : length(data.labels)
  label = labels{i};
  tLabels = find(diff(label)); % transition labels
  tIdx = randsample([true,false],length(tLabels),true,[nanProb,1-nanProb]); % random sampled positions
  fLabels = tLabels(tIdx);
  label(fLabels) = nan;
  data.labels{i} = label;
  data.nanIdx{i} = fLabels;
end

end