function trans_factor = compute_transition_factor(model, params, k, yk1, yk2)
% COMPUTE_TRANSITION_FACTOR computes the transition factors among
% (y{k},z_{k}) -> (y_{k+1},z_{k+1})
%   Detailed explanation goes here

W = exp(model.w(params.idx_w_tran));

% TODO: change transition matrix back
W = reshape(W, params.numStateYZ, params.numStateYZ);
W = W';
% transMatrix = reshape(W,params.numStateY*params.numStateZ,params.numStateY*params.numStateZ);
% norm_transMatrix = transMatrix ./ repmat(sum(transMatrix,2),1,params.numStateY*params.numStateZ);

% construct transition factor
trans_factor = struct('var', [], 'card', [], 'val', []);
trans_factor.var = [k,k+1]; % (y{k},z_{k}) -> (y_{k+1},z_{k+1})
trans_factor.card = [params.numStateYZ, params.numStateYZ];
% trans_factor.val = norm_transMatrix(:)'; % make sure it is a row vector
trans_factor.val = W(:)';

% set factor value to 0 if y violate evidence yk
if ~isempty(yk1)
  yzk1 = sub2ind(params.szYZ,ones(1,params.numStateZ)*yk1,1:params.numStateZ);
  yzk2 = sub2ind(params.szYZ,ones(1,params.numStateZ)*yk2,1:params.numStateZ);
  [a,b] = meshgrid(yzk1, yzk2);
  evidence = sparse(a(:),b(:),true,params.numStateYZ,params.numStateYZ);
  trans_factor.val(~evidence) = 0; % evidence index YZ
end

assert(isrow(trans_factor.val)) % graph factor value must be row vector

end

