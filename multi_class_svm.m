function [trainAccuracy,testAccuracy, prec, recall, fscore, confMAT] = multi_class_svm(model,params,trainData,testData,numStateZ)
% Multi-class SVM: sub-level activity as X, high-level activity as Y

% compute input X and output Y for both training
Xtrain = cell(size(trainData.HighLabels));
for i = 1 : length(Xtrain)
  % compute histogram as features
  Xtrain{i} = [histc(trainData.labels{i},1:params.numStateY);trainData.occlusion_features(i,:)'];
end
trainDataUpper.patterns = Xtrain;
trainDataUpper.labels = num2cell(trainData.HighLabels);
trainDataUpper.DimX = length(Xtrain{1});
YYY = [];
YYYY=[];
% compute input X and output Y for both training
Xtest = cell(size(testData.HighLabels)); % predicted labels
for j = 1 : length(testData.patterns)
  x = testData.patterns{j};
  yhat = ssvm_classify(params, model, x);
  YYY = [YYY;yhat];
  YYYY = [YYYY;testData.labels{j}];
  Xtest{j} = [histc(yhat,1:params.numStateY);testData.occlusion_features(j,:)'];
end
testDataUpper.patterns = Xtest;
testDataUpper.labels = num2cell(testData.HighLabels);

%%% Multi-class SVM %%%
% numStateZ = 1;
thres = 1;
initStrategy = 'learning';
% C = 15; % groundtruth high-level
% E = 0.1;
C = 10;
E = 0.01;

W = 3;
hasPartialLabel = 0;
hasLatent = 0;
model = [];
learning_option = sprintf('-c %.6f -e %.4f -w %d',C,E,W); % ssvm learning parameters

%
[model_upper,params_upper] = learning_CAD120(trainDataUpper,numStateZ,learning_option,thres,initStrategy,C,model,hasPartialLabel,hasLatent);
[~,~,trainAccuracy] = evaluate_model(trainDataUpper, model_upper, params_upper);

[gt_labels,pred_labels,testAccuracy] = evaluate_model(testDataUpper, model_upper, params_upper);

% [confMAT, prec, recall, fscore] = prec_recall(YYYY,YYY);

[confMAT, prec, recall, fscore] = prec_recall(gt_labels,pred_labels);
end
