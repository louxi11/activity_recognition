function cumError = cccp_error(params,model)

cumError = 0;

for i = 1 : length(params.labels)
    
    X = params.patterns{i};
    Y = params.labels{i};
    Z = inferLatentVariable(params, model, X, Y);
    YZ = sub2indYZ(params,Y,Z);
    
    factors = build_graphical_factors(X,params,model,[]);
    
    % add loss factors %% TODO
    loss_factors = repmat(struct('var', [], 'card', [], 'val', []), K, 1);
    for k = 1 : K
        loss_factors(k) = compute_loss_factor(params, YZ, k);
    end
    
    % combine all factors
    all_factors = [factors;loss_factors];
    
    % argmax_y delta(yi, y) + <psi(x,y), w>
    Fi = RunInference(all_factors,'pd');
    
    
    % build graphical model: factors that violate observed Y are set to zero
    factors = build_graphical_factors(X,params,model,Y);
    
    % argmax_z <phi(x,y,z), w>
    Gi = RunInference(factors,'pd');
    
    
    %%% error of data point %%% %% TODO
    cumError = cumError + abs(Fi-Gi);
    
end

end