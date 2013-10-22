% function printResults(path)
% PRINTRESULTS shows a table of results including accuracy, precision,
%   recall, and fscore.
%   Example: 
% PRINTRESULTS('groundtruth_Z%d_cp_0.00_C0.30_E0.25_W3_tfeat_on_Thre1.0_semi')

path = 'groundtruth_Z%d_cp_0.00_C0.30_E0.25_W3_tfeat_on_Thre1.0_semi';

precM = zeros(4,1);
recallM = zeros(4,1);
accuracyM = zeros(4,1);
fscoreM = zeros(4,1);

for Z = 1 : 4
  
  base = sprintf(path,Z);
  
  files = [base,'_iter3.mat'];
  
  load(files);
  
  precM(Z) = results.meanPrec;
  recallM(Z) = results.meanRecall;
  accuracyM(Z) = results.meanTest;
  fscoreM(Z) = results.meanFscore;
  
end

colHeaders = 'accuracy precision recall fscore';
rowHeaders = 'Z1 Z2 Z3 Z4';
tableData = [accuracyM,precM,recallM,fscoreM];

% Display the table of values.
printmat(tableData,path,rowHeaders,colHeaders)

% end