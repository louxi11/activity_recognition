function params = init_params( DimX, numStateY, numStateZ)
%INIT_PARAMS Summary of this function goes here
% The parameter vector is formed as follows:
% 1. unary parameters for each pixel and state: numX*(numY*numZ)  
% 2. bias(prior) parameters for each state: numY*numZ
% 3. transition parameters for pairwise states: (numY*numZ)*(numY*numZ)

% constant
params.DimX = DimX; % dimensionality of input X
params.numStateY = numStateY; % cardinality of target output Y
params.numStateZ = numStateZ;  % cadinality of latent variable Z
params.numStateYZ = numStateY * numStateZ;
params.szYZ = [numStateY, numStateZ];

% indice of unary parameters
params.idx_w_unary = 1 : params.DimX * (numStateY * numStateZ);

% indice of bias parameters
params.idx_w_bias = params.idx_w_unary(end) + 1 ...
  : params.idx_w_unary(end) + numStateY * numStateZ;

% indice of transition parameters 
params.idx_w_tran = params.idx_w_bias(end) + 1 ...
  : params.idx_w_bias(end) + numStateY^2 * numStateZ^2;

params.numParams = params.idx_w_tran(end);

end

