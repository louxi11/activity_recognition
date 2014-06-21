function hierachical_loss_factor = compute_hierachical_loss_factor( params, K, idx)

hierachical_loss_factor = struct('var', [], 'card', [], 'val', []);

YHigh = params.trainData.HighLabels(idx); % compute groundtruth Yk

if ~isnan(YHigh)
  delta_k = ones(params.numStateYHigh,1);
  delta_k(YHigh) = 0; % loss is zero when YZk is consistent with the groundtruth Y
else
  delta_k = zeros(params.numStateYHigh,1);
end

hierachical_loss_factor.var = K + 1; % yz{k}
hierachical_loss_factor.card = params.numStateYHigh;
hierachical_loss_factor.val = exp(delta_k(:)'); % libDAI 'val must be in exponential space

end