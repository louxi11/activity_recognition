function [gt_labels, pred_labels, accuracy] = evaluate_model(data, model, params)

pred_labels = cell(size(data.patterns)); % predicted labels
X = data.patterns;
for j = 1 : length(data.patterns)
  x = X{j};
  yhat = ssvm_classify(params, model, x);
  pred_labels{j} = yhat';
end
gt_labels = cellfun(@transpose,data.labels,'UniformOutput',false);
gt_labels = [gt_labels{:}]';
pred_labels = [pred_labels{:}]';
accuracy = sum(gt_labels == pred_labels) / sum(~isnan(gt_labels));

end