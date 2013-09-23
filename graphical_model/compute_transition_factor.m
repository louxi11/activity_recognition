function trans_factor = compute_transition_factor(model, params, k, yk1, yk2)
% COMPUTE_TRANSITION_FACTOR computes the transition factors among
% (y_{k},z_{k}) -> (y_{k+1},z_{k+1})
%   Detailed explanation goes here

% W now is in log space. It needs to exp when assigned to factors
W = model.w(params.idx_w_tran);

% transition (yz_{k},yz_{k+1}) with size (Y*Z) * (Y*Z)
W = reshape(W, params.numStateYZ, params.numStateYZ);

% set factor value to 0 if y violate evidence yk
if ~isempty(yk1)
  % given groudtruth yk1 and yk2, compute all permutation of (yk1,zk1) and
  % (yk2,zk2), represented in YZ space. yzk is a sparse matrix with boolean
  % values, where true values satisf the evidence yk
  yzk1 = sparse(yk1,1:params.numStateZ,true,...
    params.numStateY,params.numStateZ);
  yzk2 = sparse(yk2,1:params.numStateZ,true,...
    params.numStateY,params.numStateZ);
  
  % set entrise of W to 0 if violate evidence yzk1 and yzk2
  tran_idx = sub2ind([params.numStateYZ,params.numStateYZ],find(~yzk1(:)),find(~yzk2(:)));
  W(tran_idx) = 0;
end

if isnan(yk1)

% construct transition factor
trans_factor = struct('var', [], 'card', [], 'val', []);
trans_factor.var = [k,k+1]; % (y_{k},z_{k}) -> (y_{k+1},z_{k+1})
trans_factor.card = [params.numStateYZ, params.numStateYZ];
trans_factor.val = exp(W(:)'); % make sure it is a row vector

assert(isrow(trans_factor.val)) % graph factor value must be row vector

end

