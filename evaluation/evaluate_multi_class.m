% test sample

set_global_path

%%% sub-level parameters %%%
numStateZ = 2;          % number of latent states
C = 0.3;                % normalization constant - SVM parameter
E = 0.4;                % epsilon - SVM parameter
BaseFolder = '';
numFolds = 4;
tfeat = 'tfeat_on';
options = 'flip';      % available in next version, DO NOT CHANGE
alterProb = 0;            % number of slaves in parrallel computing
initStrategy = 'learning';
W = 3;
thres = 1;
baseFiles = {'groundtruth','m1_100','m1_500','m1_1000','m2_100','m2_500','m2_1000'};

%%
%%%
numStateZmulti = 4;

f = 1;
baseFile = baseFiles{f};
results.confMAT = zeros(10,10);
for testid = 1 : 4
  iter = 1;
  % load data
  combos = combntns(1:numFolds,3);
  train_sid = combos(testid,:);
  all_sid = 1 : 4;
  test_sid = all_sid(~ismember(all_sid,train_sid));
  baseFolder = fullfile(pwd,'CAD120','segmentation_lists');
  path = fullfile(baseFolder,baseFile);
  [trainData,testData] = load_CAD120(tfeat,train_sid,path);
  
  % load model
  dirResults = sprintf('opt_%s_Prob_%.2f_%s_C%.2f_E%.2f_W%d_%s_Thre%.1f_%s',...
    options,alterProb,baseFile,C,E,W,tfeat,thres,initStrategy);
  filebase = sprintf('%s_Z%d_C%.2f_E%.2f_W%d_%s_Thre%.1f_%s_iter%d',...
    baseFile,numStateZ,C,E,W,tfeat,thres,initStrategy,iter);
  file = fullfile(BaseFolder,dirResults,['model_',filebase,'_Test',num2str(test_sid),'.mat']);
  load(file)
  
  [trainRateUpper,testRateUpper,prec, recall, fscore,confMAT] = multi_class_svm(model,params,trainData,testData,numStateZmulti);
  results.trainRateUpper(testid) = trainRateUpper;
  results.testRateUpper(testid) = testRateUpper;
  results.prec(testid) = prec;
  results.recall(testid) = recall;
  results.fscore(testid) = fscore;
  results.confMAT = results.confMAT + confMAT;
end

% saveFile = ['results_multi_class_unigram_',baseFile];
% save(saveFile,'results')

%% Directly Evaluate High-level activities

set_global_path
f = 1;
results.confMAT = zeros(10,10);
for testid = 1 : 4
  ZZ = 1;
  % load data
  baseFile = baseFiles{f};
  combos = combntns(1:numFolds,3);
  train_sid = combos(testid,:);
  all_sid = 1 : 4;
  test_sid = all_sid(~ismember(all_sid,train_sid));
  baseFolder = fullfile(pwd,'CAD120','segmentation_lists');
  path = fullfile(baseFolder,baseFile);
  [trainData,testData] = load_CAD120(tfeat,train_sid,path);
  
  [trainRateUpper,testRateUpper, prec, recall, fscore,confMAT] = multi_class_svm_high_level(trainData,testData,ZZ);
  results.trainRateUpper(testid) = trainRateUpper;
  results.testRateUpper(testid) = testRateUpper;
  results.prec(testid) = prec;
  results.recall(testid) = recall;
  results.fscore(testid) = fscore;
  results.confMAT = results.confMAT + confMAT;
end
saveFile = ['results_multi_class_direct_',baseFile];
save(saveFile,'results')
%%
%   end
  
%   results.accMean(numStateZmulti) = mean2(testRateUpper);
%   results.accStd(numStateZmulti) = std2(testRateUpper);
%   results.precMean(numStateZmulti) = mean2(prec);
%   results.precStd(numStateZmulti) = std2(prec);
%   results.recallMean(numStateZmulti) = mean2(recall);
%   results.recallStd(numStateZmulti) = std2(recall);
%   results.fscoreMean(numStateZmulti) = mean2(fscore);
%   results.fscoreStd(numStateZmulti) = std2(fscore);
% end

saveFile = ['results_multi_class_unigram_',baseFile];
save(saveFile,'results')

% end

%% bigram

set_global_path

%%% parameters %%%
numStateZ = 2;          % number of latent states
C = 0.3;                % normalization constant - SVM parameter
E = 0.4;                % epsilon - SVM parameter

% BaseFolder = 'results_semi_supervised';
BaseFolder = '';

baseFiles = {'groundtruth','m1_100','m1_500','m1_1000'};

%%%
options = 'flip';      % available in next version, DO NOT CHANGE
alterProb = 0;            % number of slaves in parrallel computing
initStrategy = 'learning';
tfeat = 'tfeat_on';
W = 3;
thres = 1;

% for b = 1 : length(baseFiles)
%     baseFile = baseFiles{b};
%     activity_recognition_demo(numStateZ,C,E,thres,baseFile,options, ...
%                               flipProp,numCores);
% end

%
maxZ = 20;
numiter = 3;

results = [];

f = 1;
baseFile = baseFiles{f};

for numStateZmulti = 2 : 2
  
  testRateUpper = nan(4,numiter);
  prec = nan(4,numiter);
  recall = nan(4,numiter);
  fscore = nan(4,numiter);
  
  for testid = 1 : 4
    
    for iter = 1 : 3
      % load data
      numFolds = 4;
      combos = combntns(1:numFolds,3);
      train_sid = combos(testid,:);
      all_sid = 1 : 4;
      test_sid = all_sid(~ismember(all_sid,train_sid));
      baseFolder = fullfile(pwd,'CAD120','segmentation_lists');
      path = fullfile(baseFolder,baseFile);
      [trainData,testData] = load_CAD120(tfeat,train_sid,path);
      
      % load model
      dirResults = sprintf('opt_%s_Prob_%.2f_%s_C%.2f_E%.2f_W%d_%s_Thre%.1f_%s',...
        options,alterProb,baseFile,C,E,W,tfeat,thres,initStrategy);
      filebase = sprintf('%s_Z%d_C%.2f_E%.2f_W%d_%s_Thre%.1f_%s_iter%d',...
        baseFile,numStateZ,C,E,W,tfeat,thres,initStrategy,iter);
      file = fullfile(BaseFolder,dirResults,['model_',filebase,'_Test',num2str(test_sid),'.mat']);
      load(file)
      
      [~,testRateUpper(testid,iter),prec(testid,iter), recall(testid,iter), fscore(testid,iter)] = multi_class_svm2(model,params,trainData,testData,numStateZmulti);
      
    end
  end
  
  results.accMean(numStateZmulti) = mean2(testRateUpper);
  results.accStd(numStateZmulti) = std2(testRateUpper);
  results.precMean(numStateZmulti) = mean2(prec);
  results.precStd(numStateZmulti) = std2(prec);
  results.recallMean(numStateZmulti) = mean2(recall);
  results.recallStd(numStateZmulti) = std2(recall);
  results.fscoreMean(numStateZmulti) = mean2(fscore);
  results.fscoreStd(numStateZmulti) = std2(fscore);
end

saveFile = ['results_multi_class_bigram_',baseFile];
save(saveFile,'results')
%%
%% pick parameters for appearance based segmentation

set_global_path

%%% parameters %%%
numStateZ = 2;          % number of latent states
C = 0.3;                % normalization constant - SVM parameter
E = 0.4;                % epsilon - SVM parameter

% BaseFolder = 'results_semi_supervised';
BaseFolder = '';

baseFiles = {'groundtruth','m1_100','m1_500','m1_1000'};

%%%
options = 'flip';      % available in next version, DO NOT CHANGE
alterProb = 0;            % number of slaves in parrallel computing
initStrategy = 'learning';
tfeat = 'tfeat_on';
W = 3;
thres = 1;

% for b = 1 : length(baseFiles)
%     baseFile = baseFiles{b};
%     activity_recognition_demo(numStateZ,C,E,thres,baseFile,options, ...
%                               flipProp,numCores);
% end

%
maxZ = 20;
numiter = 1;

results = [];

f = 2;
baseFile = baseFiles{f};

eval_set = -6 : 0.5 : 3;

for e = 1 : 19
  for c = 20 : length(eval_set)
    EE = 2^eval_set(e);
    CC = 2^eval_set(c);
    testRateUpper = nan(4,1);
    prec = nan(4,1);
    recall = nan(4,1);
    fscore = nan(4,1);
    for testid = 1 : 4
      iter = 1;
      % load data
      numFolds = 4;
      combos = combntns(1:numFolds,3);
      train_sid = combos(testid,:);
      all_sid = 1 : 4;
      test_sid = all_sid(~ismember(all_sid,train_sid));
      baseFolder = fullfile(pwd,'CAD120','segmentation_lists');
      path = fullfile(baseFolder,baseFile);
      [trainData,testData] = load_CAD120(tfeat,train_sid,path);
      
      % load model
      dirResults = sprintf('opt_%s_Prob_%.2f_%s_C%.2f_E%.2f_W%d_%s_Thre%.1f_%s',...
        options,alterProb,baseFile,C,E,W,tfeat,thres,initStrategy);
      filebase = sprintf('%s_Z%d_C%.2f_E%.2f_W%d_%s_Thre%.1f_%s_iter%d',...
        baseFile,numStateZ,C,E,W,tfeat,thres,initStrategy,iter);
      file = fullfile(BaseFolder,dirResults,['model_',filebase,'_Test',num2str(test_sid),'.mat']);
      load(file)
      
      [~,testRateUpper(testid,iter),prec(testid,iter), recall(testid,iter), fscore(testid,iter)] = multi_class_svm3(model,params,trainData,testData,numStateZmulti,CC,EE);
      
    end
    results.accMean(c,e) = mean2(testRateUpper);
    results.accStd(c,e) = std2(testRateUpper);
    results.precMean(c,e) = mean2(prec);
    results.precStd(c,e) = std2(prec);
    results.recallMean(c,e) = mean2(recall);
    results.recallStd(c,e) = std2(recall);
    results.fscoreMean(c,e) = mean2(fscore);
    results.fscoreStd(c,e) = std2(fscore);
  end
end
% 
% saveFile = ['results_multi_class_bigram_',baseFile];
% save(saveFile,'results')
%%
load results_multi_class_unigram_m1_100
[~,maxIND] = max(results.accMean);
final.accMean(1) = results.accMean(maxIND);
final.accStd(1) = results.accStd(maxIND);
final.precMean(1) = results.precMean(maxIND);
final.precStd(1) = results.precStd(maxIND);
final.recallMean(1) = results.recallMean(maxIND);
final.recallStd(1) = results.recallStd(maxIND);

load results_multi_class_unigram_m1_500
[~,maxIND] = max(results.accMean);
final.accMean(2) = results.accMean(maxIND);
final.accStd(2) = results.accStd(maxIND);
final.precMean(2) = results.precMean(maxIND);
final.precStd(2) = results.precStd(maxIND);
final.recallMean(2) = results.recallMean(maxIND);
final.recallStd(2) = results.recallStd(maxIND);

load results_multi_class_unigram_m1_1000
[~,maxIND] = max(results.accMean);
final.accMean(3) = results.accMean(maxIND);
final.accStd(3) = results.accStd(maxIND);
final.precMean(3) = results.precMean(maxIND);
final.precStd(3) = results.precStd(maxIND);
final.recallMean(3) = results.recallMean(maxIND);
final.recallStd(3) = results.recallStd(maxIND);
