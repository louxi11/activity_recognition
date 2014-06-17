function obs_factor = compute_observation_factor( xk, model, params, k, K, yk)
%COMPUTE_TRIPLET_OBSERVATION_FACTOR Summary of this function goes here
%   Detailed explanation goes here
% evidence yk
%

assert(iscolumn(xk)) % must be a column vector

% parameter vector to matrix [X x (YxZ)]
w = reshape(model.w(params.idx_w_unary), params.DimX, params.numStateYZ);
bias  = model.w(params.idx_w_bias);

assert(iscolumn(bias))

psi_k = bsxfun(@plus, w' * xk, bias);

% psi_k = bsxfun(@minus, psi_k, max(psi_k));  % avoid numberical problem

psi_k = exp(psi_k); % potential for libDAI

% construct factor
obs_factor = struct('var', [], 'card', [], 'val', []);
if params.numStateZ > 1
  obs_factor.var = [k, k+K];
  obs_factor.card = [params.numStateY, params.numStateZ];
  obs_factor.val = psi_k';
else
  obs_factor.var = k;
  obs_factor.card = params.numStateY;
  obs_factor.val = psi_k';
end

% set factor value to 0 if y violate evidence yk
if ~isempty(yk) && ~isnan(yk) %TODO
  evidence = sparse(yk, 1:params.numStateZ, true, ...
    params.numStateY, params.numStateZ);
  obs_factor.val(~evidence) = 0; % evidence index YZ
end

assert(isrow(obs_factor.val)) % factor value must be a row vector

end