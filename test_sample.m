% test sample

%%% parameters %%%
numStateZ = '4';
C = '0.3'; % normalization constant
E = '0.4'; % epsilon
thres = '10'; % threshold to stop iteration TODO
baseFile = 'uniform_20_0';

% turn on parrallel computing
options = 'corrupt';
flipProp = '0';
numCores = '4'; % number of slaves

activity_recognition_demo(numStateZ,C,E,thres,baseFile,options,flipProp,numCores);