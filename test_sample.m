% test sample

%%% parameters %%%
numStateZ = '1';
C = '0.3'; % normalization constant
E = '0.4'; % epsilon
thres = '1'; % threshold to stop iteration TODO
baseFile = 'uniform_20_10';
corruptPercentage = 'inf'; % change only transition label

% turn on parrallel computing
par_on = 'true';
semi_supervised_template(numStateZ,C,E,thres,baseFile,corruptPercentage,par_on)