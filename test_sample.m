% test sample

%%% parameters %%%
numStateZ = '4'; % number of latent states
C = '0.3'; % normalization constant - SVM
E = '0.4'; % epsilon - SVM
thres = '1'; % threshold to stop CCCP iteration
baseFile = 'groundtruth'; % dataset to evaluate

%%% new functions: TODO
options = 'corrupt';
flipProp = '0';
numCores = '1'; % number of slaves in parrallel computing

activity_recognition_demo(numStateZ,C,E,thres,baseFile,options,flipProp,numCores);