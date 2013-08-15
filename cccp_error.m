function cumError = cccp_error(params,trainData,model)
% after learning, model holds new parameters model.w, recompute optimal
% value to measure cumulative error over data

cumError = 0;

for i = 1 : length(params.labels)
       
    X = params.patterns{i};
    Y = trainData.labels{i};
    YZ = sub2ind(params.szYZ, Y, ones(size(Y))); % Z does not matter when computing loss function
    
    % argmax_y delta(yi, y) + <psi(x,y), w>
    [~,Fi] = constraintCB(params, model, X, YZ);
    
    %%% ----------------------------------------- %%%
    
    % argmax_z <phi(x,y,z), w>
    [~,Gi] = inferLatentVariable(params, model, X, Y);
    
    %%% error of data point %%% %% TODO
    cumError = cumError + abs(Fi-Gi);
    
end

end