function params = init_params( trainData, DimX, numStateY, numStateZ, initStrategy)
%INIT_PARAMS Summary of this function goes here
% The parameter vector is formed as follows:
% 1. unary parameters for each pixel and state: numX*(numY*numZ)  
% 2. bias(prior) parameters for each state: numY*numZ
% 3. transition parameters for pairwise states: (numY*numZ)*(numY*numZ)

strategy = {'random','clustering','affordance'};
if sum(strcmp(initStrategy,strategy)) == 0
  error('init_params: Unknown initStrategy, Possible options are "random","clustering","affordance"\n')
end
  
% dimensionality constant
params.DimX = DimX; % dimensionality of input X
params.numStateY = numStateY; % cardinality of target output Y
params.numStateZ = numStateZ;  % cadinality of latent variable Z
params.numStateYZ = numStateY * numStateZ;
params.szYZ = [numStateY, numStateZ];

% indice of unary parameters
params.idx_w_unary = 1 : params.DimX * numStateY ;

% indice of bias parameters
params.idx_w_bias = params.idx_w_unary(end) + 1 ...
  : params.idx_w_unary(end) + numStateY * numStateZ;

% indice of transition parameters 
params.idx_w_tran = params.idx_w_bias(end) + 1 ...
  : params.idx_w_bias(end) + numStateY^2 * numStateZ^2;

params.numParams = params.idx_w_tran(end);

% constant
params.cnt = 1;
params.need_init = true;
params.cumErrorPrev = inf;
params.initStrategy = initStrategy;

% structured svm parameters
params.patterns = trainData.patterns;
params.dimension = params.idx_w_tran(end);
params.verbose = 0 ;
params.lossFn = @lossCB ;
params.constraintFn  = @constraintCB ;
params.featureFn = @featureCB ;

end

