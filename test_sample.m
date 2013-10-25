% test sample

%%% parameters %%%
numStateZ = '1';
C = '0.3'; % normalization constant
E = '0.25'; % epsilon
thres = '1'; % threshold to stop iteration TODO
baseFile = 'groundtruth';
corruptPercentage = '0'; % change only transition label

% turn on parrallel computing
matlabpool('open','local',4);
fprintf('Using %d cores\n',matlabpool('size'));
semi_supervised_template(numStateZ,C,E,thres,baseFile,corruptPercentage)