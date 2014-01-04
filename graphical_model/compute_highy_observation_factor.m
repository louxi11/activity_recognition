function highy_factor = compute_highy_observation_factor( OccX, model, params, K, yhigh)

% assert(iscolumn(xk)) % must be a column vector

% parameter vector to matrix [X x (YxZ)]
w = reshape(model.w(params.idx_w_yhigh_unary), params.DimOcclusionX, params.numStateYHigh);
% w = zeros(params.DimX, params.numStateYHigh);
bias  = model.w(params.idx_w_yhigh_bias);

assert(iscolumn(bias))

psi_k = bsxfun(@plus, w' * OccX, bias);

% psi_k = bsxfun(@minus, psi_k, max(psi_k));  % avoid numberical problem

psi_k = exp(psi_k); % potential for libDAI

% construct factor
highy_factor = struct('var', [], 'card', [], 'val', []);
highy_factor.var = K + 1;
highy_factor.card = params.numStateYHigh;
highy_factor.val = psi_k';

% set factor value to 0 if y violate evidence yk
if ~isempty(yhigh) && ~isnan(yhigh) %TODO
  evidence = true(params.numStateYHigh, 1);
  highy_factor.val(~evidence) = 0; % evidence index YZ
end

assert(isrow(highy_factor.val)) % factor value must be a row vector

end