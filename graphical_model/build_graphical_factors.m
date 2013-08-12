function factors = build_graphical_factors(X, params, model)
% collect all factors of the graph into a vector

K = length(X) / params.DimX; % number of time slices
X = reshape(X,params.DimX,K);

% allocate empty factors
factors = repmat(struct('var', [], 'card', [], 'val', []), 2 * K - 1, 1);

% all observation factors
for k = 1 : K
    xk = X(:,k);
    factors(k) = compute_observation_factor(xk,model,params,k);
end

% all transition factors
for k = 1 : K - 1
    factors(K+k) = compute_transition_factor(model,params,k);
end

% check if all factors are non-empty
for k = 1 : length(factors)
    if isempty(factors(k))
        error('graphical model contains empty factor');
    end
end

end