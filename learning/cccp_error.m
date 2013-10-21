function cumError = cccp_error(params,trainData,model,C)
% after learning, model holds new parameters model.w, recompute optimal
% value to measure cumulative error over data

%%% TODO USE MEX FUNCTION TO GET CUMERROR< NOT DO INFERENCE AGAIN

F = zeros(1,length(params.labels));
for i = 1 : length(params.labels)

    X = params.patterns{i};
    Y = trainData.labels{i};
    YZ = sub2ind(params.szYZ, Y, ones(size(Y))); % assign an arbitrary Z because Y will be recoverd when compute loss factor

    % max_yz (delta(yzi, yz) + <psi(xi,yz), w>)
    [temp,F(i)] = constraintCB(params, model, X, YZ,i);
end
Fsum = (norm(model.w)^2)/2 + C * sum(F);

G = zeros(1,length(params.labels));
for i = 1 : length(params.labels)
    X = params.patterns{i};
    Y = trainData.labels{i}; % groundtruth labels

    % argmax_z <phi(xi,yi,z), w>
    [temp,G(i)] = inferLatentVariable(params, model, X, Y);
end
Gsum = C * sum(G);

cumError = Fsum - Gsum; % don't forget the regularization...

end