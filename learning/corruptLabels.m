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
  % set transition nodes to nan
  for i = 1 : length(data.labels)
    label = labels{i};
    c = SplitVec(label);
    len = cellfun('length',c);
    cumlen = cumsum(len);
    mask = len >= 5;
    if sum(mask)
      frontLabel = cumlen(mask) - len(mask) + 1;
      endLabel = cumlen(mask);
      if frontLabel(1) == 1
        frontLabel(1) = [];
      end
      if endLabel(end) == cumlen(end)
        endLabel(end) = [];
      end
      idx = [frontLabel;endLabel];
      label(idx) = nan;
    end
    data.labels{i} = label;
  end
end

end