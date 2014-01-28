% test sample

%%% parameters %%%
numStateZ = '4';          % number of latent states
C = '0.3';                % normalization constant - SVM parameter
E = '0.4';                % epsilon - SVM parameter
thres = '1';              % threshold to stop CCCP iteration
baseFile = 'groundtruth'; % dataset to evaluate

%%% new functions: TODO
options = 'corrupt';      % available in next version
flipProp = '0';           % available in next version
numCores = '1';           % number of slaves in parrallel computing

activity_recognition_demo(numStateZ,C,E,thres,baseFile,options,flipProp,numCores);