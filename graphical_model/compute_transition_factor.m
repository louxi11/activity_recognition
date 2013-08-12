function trans_factor = compute_transition_factor( model, params, k )
% COMPUTE_TRANSITION_FACTOR computes the transition factors among
% (y{k},z_{k}) -> (y_{k+1},z_{k+1})
%   Detailed explanation goes here

W = exp(model.w(params.idx_w_tran));

% TODO: change transition matrix back
W = reshape(W,params.numStateY*params.numStateZ,params.numStateY*params.numStateZ);
W = W';
% transMatrix = reshape(W,params.numStateY*params.numStateZ,params.numStateY*params.numStateZ);
% norm_transMatrix = transMatrix ./ repmat(sum(transMatrix,2),1,params.numStateY*params.numStateZ);

% construct transition factor
trans_factor = struct('var', [], 'card', [], 'val', []);
trans_factor.var = [k,k+1]; % (y{k},z_{k}) -> (y_{k+1},z_{k+1})
trans_factor.card = [params.numStateY*params.numStateZ,params.numStateY*params.numStateZ];
% trans_factor.val = norm_transMatrix(:)'; % make sure it is a row vector
trans_factor.val = W(:)';

assert(isrow(trans_factor.val)) % graph factor value must be row vector

end

