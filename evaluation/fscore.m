function [confMtx, prec, recall, F] = fscore(prediction,groundtruth)
  
  if ~isvector(prediction) || ~isvector(groundtruth)
    error('input must be a vector');
  elseif length(prediction) ~= length(groundtruth)
    error('input vector must have the same length');
  end
  
  if ~islogical(prediction)
    prediction = logical(prediction);
  end
  
  if ~islogical(groundtruth)
    groundtruth = logical(groundtruth);
  end
  
  TP = sum(prediction & groundtruth);
  FP = sum(prediction & ~groundtruth);
  FN = sum(~prediction & groundtruth);
  TN = sum(~prediction & ~groundtruth);
  
  confMtx = [TP FP;FN TN];
  prec = TP / (TP+FP);
  recall = TP / (TP+FN);
  F = 2*prec*recall/(prec + recall);
  
end