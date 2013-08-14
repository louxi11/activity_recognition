function loss_factor = compute_loss_factor( params, YZ, k)
%COMPUTE_LOSS_FACTOR Summary of this function goes here
%   Detailed explanation goes here

loss_factor = struct('var', [], 'card', [], 'val', []);

delta_k = double(((1:params.numStateYZ) - YZ(k)) ~= 0); % TODO: classification error?
% delta_k = double(((1:params.numStateY) - Y(k)));

loss_factor.var = k; % y{k}
loss_factor.card = params.numStateYZ;
loss_factor.val = exp(delta_k); % libDAI 'val must be in exponential space

end