function loss_factor = compute_loss_factor( params, k, idx)
%COMPUTE_LOSS_FACTOR Summary of this function goes here
%   compute the loss factor delta(yi,YZ), YZ is a random variable
% only the difference of Y cares, Z does not matter that much

loss_factor = struct('var', [], 'card', [], 'val', []);

Yk = params.trainData.labels{idx}(k); % compute groundtruth Yk

if ~isnan(Yk)
  delta_k = ones(params.numStateY,params.numStateZ);
  delta_k(Yk,:) = 0; % loss is zero when YZk is consistent with the groundtruth Yk
else
  delta_k = zeros(params.numStateY,params.numStateZ);
end

loss_factor.var = k; % yz{k}
loss_factor.card = params.numStateYZ;
loss_factor.val = exp(delta_k(:)'); % libDAI 'val must be in exponential space

end