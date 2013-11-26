function [data, partialLabelFlag] = flipLabels(data,lenThres)

labels = data.labels;

% set transition nodes to nan
for i = 1 : length(data.labels)
  label = labels{i};
  c = SplitVec(label);
  len = cellfun('length',c);
  cumlen = cumsum(len);
  mask = len >= lenThres;
  if sum(mask)
    frontLabel = cumlen(mask) - len(mask) + 1;
    endLabel = cumlen(mask);
    if frontLabel(1) == 1
      frontLabel(1) = [];
    end
    if endLabel(end) == cumlen(end)
      endLabel(end) = [];
    end
    %       idx = [frontLabel;endLabel];
    label(frontLabel) = label(frontLabel-1);
    label(endLabel) = label(endLabel+1);
  end
  data.labels{i} = label;
end

partialLabelFlag = false;

end