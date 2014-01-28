% test sample

%%% parameters %%%
numStateZ = '2';          % number of latent states
C = '0.3';                % normalization constant - SVM parameter
E = '0.4';                % epsilon - SVM parameter
thres = '1';              % threshold to stop CCCP iteration
baseFile = 'groundtruth'; % dataset to evaluate

%%% new functions: TODO
options = 'flip';      % available in next version, DO NOT CHANGE
flipProp = '0';           % available in next version, DO NOT CHANGE
numCores = '1';           % number of slaves in parrallel computing

activity_recognition_demo(numStateZ,C,E,thres,baseFile,options,flipProp,numCores);