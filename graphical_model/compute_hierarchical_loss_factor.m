function hierarchical_loss_factor = compute_hierarchical_loss_factor( params, K, idx)

hierarchical_loss_factor = struct('var', [], 'card', [], 'val', []);

YHigh = params.trainData.HighLabels(idx); % compute groundtruth Yk

if ~isnan(YHigh)
  delta_k = ones(params.numStateYHigh,1);
  delta_k(YHigh) = 0; % loss is zero when YZk is consistent with the groundtruth Y
else
  delta_k = zeros(params.numStateYHigh,1);
end

hierarchical_loss_factor.var = K + 1; % yz{k}
hierarchical_loss_factor.card = params.numStateYHigh;
hierarchical_loss_factor.val = exp(delta_k(:)'); % libDAI 'val must be in exponential space

end