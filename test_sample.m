% test sample

%%% parameters %%%
numStateZ = '1';
C = '0.3'; % normalization constant
E = '0.4'; % epsilon
thres = '1'; % threshold to stop iteration TODO
baseFile = 'groundtruth';

% turn on parrallel computing
options = 'corrupt';
flipProp = '0';
tic
numCores = '4'; % number of slaves

semi_supervised_template(numStateZ,C,E,thres,baseFile,options,flipProp,numCores)
toc