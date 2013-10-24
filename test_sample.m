% test sample

%%% parameters %%%
numStateZ = 1;
C = 0.3; % normalization constant
E = 1.7; % epsilon
thres = 7; % threshold to stop iteration TODO
baseFile = 'groundtruth';
corruptPercentage = 0; % change only transition label

semi_supervised_template(numStateZ,C,E,thres,baseFile,corruptPercentage)