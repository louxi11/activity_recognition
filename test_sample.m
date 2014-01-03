% test sample

%%% parameters %%%
numStateZ = '2';
C = '0.3'; % normalization constant
E = '0.4'; % epsilon
thres = '50'; % threshold to stop iteration TODO
baseFile = 'uniform_20_0';

% turn on parrallel computing
options = 'corrupt';
flipProp = '0.1';
numCores = '1'; % number of slaves

semi_supervised_template(numStateZ,C,E,thres,baseFile,options,flipProp,numCores);