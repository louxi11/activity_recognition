function cumError = cccp_error(params,trainData,model,C)
% after learning, model holds new parameters model.w, recompute optimal
% value to measure cumulative error over data

%%% TODO USE MEX FUNCTION TO GET CUMERROR< NOT DO INFERENCE AGAIN

% score of convex term
F = zeros(1,length(params.labels));
patterns = params.patterns;
labels = trainData.labels;
sz = params.szYZ;
for i = 1 : length(params.labels)

    X = patterns{i};
    Y = labels{i};
    YZ = [Y; ones(size(Y))]; % assign an arbitrary Z because Y will be recoverd when compute loss factor

    % max_yz (delta(yzi, yz) + <psi(xi,yz), w>)
    [~,F(i)] = constraintCB(params, model, X, YZ,i);
end
Fsum = (norm(model.w)^2)/2 + C * sum(F);

% score of concave term
G = zeros(1,length(params.labels));
patterns = params.patterns;
labels = trainData.labels;
for i = 1 : length(params.labels)
    X = patterns{i};
    Y = labels{i}; % groundtruth labels

    % argmax_z <phi(xi,yi,z), w>
    [~,G(i)] = inferLatentVariable(params, model, X, Y);
end
Gsum = C * sum(G);

% final score
cumError = Fsum - Gsum;

end