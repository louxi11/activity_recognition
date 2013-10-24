% test sample

%%% parameters %%%
numStateZ = '4';
C = '0.3'; % normalization constant
E = '1.7'; % epsilon
thres = '7'; % threshold to stop iteration TODO
baseFile = 'm2_500';
corruptPercentage = 'inf'; % change only transition label

semi_supervised_template(numStateZ,C,E,thres,baseFile,corruptPercentage)