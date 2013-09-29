% function evaluation_template

clc
% clear all
diary off

addpath graphical_model/
addpath inference/
addpath learning
addpath svm-struct-matlab-1.2/
addpath tools/
addpath evaluation/

addpath test_data/

save_on = 1;

corruptPercentage = 0;

%%% parameters %%%
numStateZ = 1;
C = 0.3; % normalization constant
E = 0.25; % epsilon
W = 3; % optimization strategy
tfeat = 'tfeat_on';
thres = 1; % threshold to stop iteration TODO
% thres = C * E; % threshold to stop iteration TODO
initStrategy = 'clustering'; % semi supervised

eval_set = 1:3;
iter = 1;
c=1;

%%% allocate buffer %%%
trainRate = nan(4,length(eval_set));
testRate = nan(4,length(eval_set));
prec = nan(4,length(eval_set));
recall = nan(4,length(eval_set));
fscore = nan(4,length(eval_set));
confmat = cell(4,length(eval_set));

% 4 fold cross-validation
combos = combntns(1:4,3);

% for c = 1 : length(eval_set)
  
  iter = 1;
  AA = [];
  for numStateZ = 1 : 4
  %%% learning %%%
%   for i = 1 : size(combos,1)
    i=1;
    % select video for training set
    train_sid = combos(i,:);
    all_sid = 1 : 4;
    test_sid = all_sid(~ismember(all_sid,train_sid));
    
    filebase = sprintf('Z%d_cp_%.2f_C%.2f_E%.2f_W%d_%s_Thre%.1f_%s_iter%d',numStateZ,corruptPercentage,C,E,W,tfeat,thres,initStrategy,iter);
    if save_on
      logfile = sprintf([filebase,'_Test%d'],test_sid);
%       make_log(logfile); % LOG file and SAVE MODEL
    end
    
    % load structured svm options
    learning_option = sprintf('-c %.2f -e %.2f -w %d',C,E,W); % ssvm learning parameters
    
    % split training and test data
    [trainData,testData] = load_CAD120('parse_off',tfeat,train_sid);
%     trainData = corruptLabels(trainData,corruptPercentage);
    
    % learning
%     [model,params] = learning_CAD120(trainData,numStateZ,learning_option,thres,initStrategy,C);
    
    % save model to file
%     if save_on
%       save(['model_',logfile,'.mat'],'model','params','trainData','testData')
%     end
    load(['results_semi_supervised_cp/model_',logfile,'.mat'],'model','params')
    

    %%% classification %%%
    
    CNT1 = 0;
    Time1 = [];
    vidLength1 = [];
    D = 0;
    tic
    data = trainData;
    for j = 1 : length(data.patterns)
      X_test = data.patterns{j};
      startTime = toc;
      yhat = ssvm_classify(params, model, X_test); % TODO bugs for classification
      ts = toc - startTime;
      len = length(X_test)/params.DimX;
      D = D + sum( int32(data.labels{j}) == int32(yhat));
      Time1 = [Time1,ts];
      vidLength1 = [vidLength1,len];
      CNT1 = CNT1 + length(data.labels{j});
    end
    trainRate(i,c) = D/CNT1;
    
    CNT = 0;
    D = 0;
    Time2 = [];
    vidLength2 = [];
    GT = [];
    PRED = [];
    data = testData;
    for j = 1 : length(data.patterns)
      X_test = data.patterns{j};
      startTime = toc;
      yhat = ssvm_classify(params, model, X_test);
      ts = toc - startTime;
      len = length(X_test)/params.DimX;
      D = D + sum( int32(data.labels{j}) == int32(yhat));
      Time2 = [Time2,ts];
      vidLength2 = [vidLength2,len];
      CNT = CNT + length(data.labels{j});
    end
    testRate(i,c) = D/CNT;
    
    LEN = [vidLength1,vidLength2];
    TIME = [Time1,Time2];


    VAL = zeros(1,max(LEN));
    CNT = VAL;
    for i = 1 : length(LEN)
      VAL(LEN(i)) = VAL(LEN(i)) + TIME(i);
      CNT(LEN(i)) = CNT(LEN(i)) + 1;
    end
    A = VAL./CNT;
    A(1) = [];
    mnan = isnan(A);
    for i = find(mnan)
      A(i) = mean([A(i+1),A(i-1)]);
    end
    AA = [AA;A];
  end
  hold off
  plot(2:size(AA,2)+1,AA(1,:),'r-*');
  hold on;
  plot(2:size(AA,2)+1,AA(2,:),'b-*');
  plot(2:size(AA,2)+1,AA(3,:),'g-*');
  plot(2:size(AA,2)+1,AA(4,:),'m-*');
  
  xlabel('Video length (number of segments)','FontSize',13)
  ylabel('Inference runtime per video (seconds)','FontSize',13)
  legend('Semi. Latent-1','Semi. Latent-2','Semi. Latent-3','Semi. Latent-4');
