function [Yhat,Zhat] = ssvm_classify(params, model, X)
%CONSTRAINCB Summary of this function goes here
%  compute the augmented inference problem
%  Yhat = argmax_y(delta(y,yhat),psi(x,y;w))
%  psi(x,y;w) is a graph model, and each y node in the graph is connected
%  with a delta
%  the argmax is computed by MAP inference using libDAI

assert(length(model.w) == params.dimension)
assert(iscolumn(X))

% build graphical model
factors = build_graphical_factors(X,params,model,[]);

% argmax_y <psi(x,y), w>
YZhat = RunInference(factors);

[Yhat,Zhat] = splitYZ(params.numStateZ,YZhat);

end