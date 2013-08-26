% % evaluate script for latent Z
% 
% clear all
% clc
% Z = 2;
% C = 0.4;
% E = 0.5;
% W = 3;
% thres = 1;
% eval_test(Z,C,E,W,thres);
% 
% Z = 3;
% C = 0.4;
% E = 0.5;
% W = 3;
% thres = 1;
% eval_test(Z,C,E,W,thres);
% 
% Z = 4;
% C = 0.4;
% E = 0.5;
% W = 3;
% thres = 1;
% eval_test(Z,C,E,W,thres);
% 
% Z = 3;
% C = 0.4;
% E = 0.25;
% W = 3;
% thres = 1;
% eval_test(Z,C,E,W,thres);
% 
% Z = 2;
% C = 0.4;
% E = 0.25;
% W = 4;
% thres = 5;
% eval_test(Z,C,E,W,thres);

% Z = 4;
% C = 0.4;
% E = 0.25;
% W = 4;
% thres = 5;
% eval_test(Z,C,E,W,thres);
% 

Z = 3;
C = 0.4;
E = 0.25;
W = 3;
thres = 1.0;
initStrategy = 'random';
eval_test(Z,C,E,W,thres,initStrategy);

Z = 3;
C = 0.3;
E = 0.25;
W = 3;
thres = 1.0;
initStrategy = 'random';
eval_test(Z,C,E,W,thres,initStrategy);