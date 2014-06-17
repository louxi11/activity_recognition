function trans_factor = compute_transition_factor(model, params, k, K, yk1, yk2)
% COMPUTE_TRANSITION_FACTOR computes the transition factors among
% (y_{k},z_{k}) -> (y_{k+1},z_{k+1})
%   Detailed explanation goes here

% W now is in log space. It needs to exp when assigned to factors
W = model.w(params.idx_w_tran);

% transition (yz_{k},yz_{k+1}) with size (Y*Z) * (Y*Z)
W = reshape(W, params.numStateYZ, params.numStateYZ);

% set factor value to 0 if y violate evidence yk
if ~isempty(yk1) && ~(isnan(yk1)&&isnan(yk2))
  % given groudtruth yk1 and yk2, compute all permutation of (yk1,zk1) and
  % (yk2,zk2), represented in YZ space. yzk is a sparse matrix with boolean
  % values, where true values satisf the evidence yk
  if ~isnan(yk1)
    yzk1 = sparse(yk1,1:params.numStateZ,true,...
      params.numStateY,params.numStateZ);
  else
    yzk1 = true(params.numStateY,params.numStateZ);
  end
  if ~isnan(yk2)
    yzk2 = sparse(yk2,1:params.numStateZ,true,...
      params.numStateY,params.numStateZ);
  else
    yzk2 = true(params.numStateY,params.numStateZ);
  end
  
  % set entrise of W to 0 if violate evidence yzk1 and yzk2
%   [m1,m2] = meshgrid(find(yzk1(:)),find(yzk2(:)));
%   tran_idx = true(params.numStateYZ,params.numStateYZ);
%   tran_idx(m1(:),m2(:)) = false;
%   W1 = W;
%   W1(tran_idx(:)) = 0;
  W(~yzk1(:),:) = 0;
  W(:,~yzk2(:)) = 0;

end

% construct transition factor
trans_factor = struct('var', [], 'card', [], 'val', []);
if params.numStateZ > 1
  trans_factor.var = [k,k+K,k+1,k+K+1]; % (y_{k},z_{k}) -> (y_{k+1},z_{k+1})
  trans_factor.card = [params.numStateY,params.numStateZ,params.numStateY,params.numStateZ];
  trans_factor.val = exp(W(:)'); % mak1e sure it is a row vector
else
  trans_factor.var = [k,k+1]; % (y_{k},z_{k}) -> (y_{k+1},z_{k+1})
  trans_factor.card = [params.numStateY,params.numStateY];
  trans_factor.val = exp(W(:)'); % mak1e sure it is a row vector
end

assert(isrow(trans_factor.val)) % graph factor value must be row vector

end

