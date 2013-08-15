function loss_factor = compute_loss_factor( params, YZ, k)
%COMPUTE_LOSS_FACTOR Summary of this function goes here
%   compute the loss factor delta(yi,YZ), YZ is a random variable
% only the difference of Y cares, Z does not matter that much

loss_factor = struct('var', [], 'card', [], 'val', []);

YZk = YZ(k);
[Yk,~] = ind2subYZ(params,YZk);

delta_k = ones(params.numStateY,params.numStateZ);
delta_k(Yk,:) = 0; % loss is zero when YZk is consistent with the groundtruth Yk

loss_factor.var = k; % yz{k}
loss_factor.card = params.numStateYZ;
loss_factor.val = exp(delta_k(:)); % libDAI 'val must be in exponential space

end