function obs_factor = compute_observation_factor( xk, model, params, k, yk)
%COMPUTE_TRIPLET_OBSERVATION_FACTOR Summary of this function goes here
%   Detailed explanation goes here
% evidence yk
%

assert(iscolumn(xk)) % must be a column vector

% parameter vector to matrix [X x (YxZ)]
w = reshape(model.w(params.idx_w_unary), params.DimX, params.numStateY);
bias  = model.w(params.idx_w_bias);

assert(iscolumn(bias))

psi_y = w' * xk;

% psi_k = bsxfun(@minus, psi_k, max(psi_k));  % avoid numberical problem
psi_k = zeros(params.szYZ);
for i = 1 : params.numStateY
  psi_k(i,:) = psi_y(i);
end

psi_k = psi_k(:) + bias;

psi_k = exp(psi_k(:)); % potential for libDAI

% construct factor
obs_factor = struct('var', [], 'card', [], 'val', []);
obs_factor.var = k;
obs_factor.card = params.numStateYZ;
obs_factor.val = psi_k';

% set factor value to 0 if y violate evidence yk
if ~isempty(yk)
  evidence = sparse(yk, 1:params.numStateZ, true, ...
    params.numStateY, params.numStateZ);
  obs_factor.val(~evidence) = 0; % evidence index YZ
end

assert(isrow(obs_factor.val)) % factor value must be a row vector

end