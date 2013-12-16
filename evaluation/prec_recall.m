function [confmat, prec, recall, fscore] = prec_recall(groundtruth,prediction)

if ~iscolumn(prediction) || ~iscolumn(groundtruth)
  error('input must be column vectors');
elseif length(prediction) ~= length(groundtruth)
  error('input vectors must have the same length');
end

M = confusionmat(groundtruth,prediction);
P = sum(M,1); % positive detection
N = sum(M,2); % negtive detection

prec = nan(size(M,1),1);
recall = nan(size(M,1),1);

for i = 1:size(M,1)
  prec(i) = M(i,i) / P(i);
  recall(i) = M(i,i) / N(i);
end
fscore = 2 * prec .* recall ./ (prec + recall);

prec = mean(prec);
recall = mean(recall);
fscore = mean(fscore);

confmat = bsxfun(@times, M, 1./(sum(M, 2)));

end