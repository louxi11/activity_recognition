% test sample

%%% parameters %%%
numStateZ = '1';
C = '0.3'; % normalization constant
E = '0.4'; % epsilon
thres = '1'; % threshold to stop iteration TODO
baseFile = 'uniform_20_10';
corruptPercentage = 'inf'; % change only transition label

% turn on parrallel computing
par_on = 'false';
options = 'corrupt';
flipProp = '0.5';
numCores = '3';
semi_supervised_template(numStateZ,C,E,thres,baseFile,par_on,options,flipProp,numCores)