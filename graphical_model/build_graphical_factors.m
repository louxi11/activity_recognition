function factors = build_graphical_factors(X, params, model, ObsY)
% collect all factors of the graph into a vector

K = size(X,1) / params.DimX; % number of time slices

X = reshape(X,params.DimX,K);

assert(isempty(ObsY) | length(ObsY) == K)

% allocate empty factors
factors = repmat(struct('var', [], 'card', [], 'val', []), 2 * K - 1, 1);

% all observation factors
if isempty(ObsY)
  for k = 1 : K
    xk = X(:,k);
    factors(k) = compute_observation_factor(xk,model,params,k,K,[]);
  end
else
  for k = 1 : K
    xk = X(:,k);
    factors(k) = compute_observation_factor(xk,model,params,k,K,ObsY(k));
  end
end

% all transition factors
if isempty(ObsY)
  for k = 1 : K - 1
    factors(K+k) = compute_transition_factor(model,params,k,K,[],[]);
  end
else
  for k = 1 : K - 1
    factors(K+k) = compute_transition_factor(model,params,k,K,ObsY(k),ObsY(k+1));
  end
end

% check if all factors are non-empty
for k = 1 : length(factors)
  if isempty(factors(k))
    error('graphical model contains empty factor');
  end
end

end