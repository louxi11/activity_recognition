function obs_factor = compute_observation_factor( xk, model, params ,k)
%COMPUTE_TRIPLET_OBSERVATION_FACTOR Summary of this function goes here
%   Detailed explanation goes here

assert(iscolumn(xk)) % must be a column vector

% parameter vector to matrix [X x (YxZ)]
w = reshape(model.w(params.idx_w_unary), params.DimX, params.numStateY * params.numStateZ);
bias  = reshape(model.w(params.idx_w_bias), params.numStateY * params.numStateZ, 1); %% MARK

psi_k = bsxfun(@plus, w' * xk, bias);

% psi_k = bsxfun(@minus, psi_k, max(psi_k));  % avoid numberical problem

psi_k = exp(psi_k); % potential for libDAI

% construct factor
obs_factor = struct('var', [], 'card', [], 'val', []);
obs_factor.var = k;
obs_factor.card = params.numStateY * params.numStateZ;
obs_factor.val = psi_k';

assert(isrow(obs_factor.val)) % factor value must be a row vector

end