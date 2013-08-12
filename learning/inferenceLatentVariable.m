function Zhat = inferenceLatentVariable(params, model, X, Y)
%CONSTRAINCB Summary of this function goes here
%  compute the augmented inference problem
%  zi = argmax_z(psi(xi,yi,z;w)) where psi(xi,yi,z;w) = <w,phi(xi,yi,z)>
%  psi(x,y,z;w) is a graph model and psi is the feature vector
%  the argmax is computed by MAP inference using libDAI

assert(length(model.w) == params.dimension)
assert(iscolumn(X))
assert(iscolumn(Y))

% length of sequence
K = length(X) / params.DimX;

% build graphical model: Y, Z are collapsed into a single node
factors = build_graphical_factors(X,params,model);

% compute evidence after observing Y
[a,b] = meshgrid(Y,1:params.numStateZ);
evidence = sub2ind([params.numStateY,params.numStateZ],a,b); % evidence index YZ

% if not 1evidence, set factor value to zero
factors = observe_evidence(factors,evidence);

% argmax_z <phi(x,y,z), w>
YZ = RunInference(factors);
[Yhat,Zhat] = ind2sub([params.numStateY,params.numStateZ],YZ);

Zhat = Zhat';
assert(iscolumn(Zhat))
assert(Y == Yhat');

end