%% LOAD DATA (Word Recognition)
clc
clear all

addpath graphical_model/
addpath inference/
addpath learning
% addpath singleton_graphical_model/
addpath svm-struct-matlab-1.2/

addpath test_data/

% dataset Word Recognition
[trainData,testData] = load_word_recognition_data;
DimX = 64;
numStateY = 26;
numStateZ = 1;

% % dataset Word Recognition for testing factors PGM 7
% [trainData,testData] = load_word_recognition_data_factors;
% DimX = 64;
% numStateY = 26;
% numStateZ = 1;

% % dataset Word Recognition Small
% trainData = load_word_recognition_small_data;
% DimX = 16*8;
% numStateY = 26;
% numStateZ = 1;

% dataset for multiple class svm
% [patterns,labels] = load_example4_data;
% DimX = size(patterns{1},2);
% numStateY = 7;
% numStateZ = 1;

%% LEARNING
% param.patterns is a cell array of inputs X. Each cell X{i} corresponds with one
% observation sequence. The rows of one cell has MxN dimension, which means
% there are M observation (time slices) and for each time slice there is a 
% N dimensional observation
% parm.labels is a cell array of output target Y. The structure of the cell
% is similar to X 

% parameter settings
params = init_params(DimX, numStateY, numStateZ);
params.patterns = trainData.patterns;
params.labels = trainData.labels;
params.dimension = params.idx_w_tran(end);
params.verbose = 0 ;
params.lossFn = @lossCB ;
params.constraintFn  = @constraintCB ;
params.featureFn = @featureCB ;

%% STRUCTURED-SVM LEARNING
%  svm_struct_learn is a function that calls three matlab functions
%  1. lossCB: delta(y,yhat), it returns the number of misclassified labels
%     of the sequence
%  2. featureCB: psi(x,y;w) returns a feature vector which has the same
%     size as the parameters vector w
%  3. constraintCB: compute yhat = argmax_y(delta(y,yhat),psi(x,y;w))
%     where psi(x,y;w) = <w,phi(x,y)>


% -y verbose level on svm light
% -v verbose leve on ssvm

% -c C
% -p L-norm to use for slack variables
% -w optimization option
% -o 2 rescaling method Margin rescaling
%  Check svm_struct_learn.m for all the auguments description
model = svm_struct_learn('-c 1 -e 0.1 -o 2 -w 3 -l 1', params) ;
w = model.w;

%% Classification
% load charRecognitionSmall
load test_data/model_WordRecognition
C = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
CNT = 0;
D = 0;
data = testData;
for i = 1 : length(data.patterns)
  X_test = data.patterns{i};
  yhat = ssvm_classify(params, model, X_test);
  disp([data.labels{i}';yhat'])
  D = D + sum((data.labels{i} - yhat) == 0);
  CNT = CNT + length(data.labels{i});
end
disp(D/CNT)