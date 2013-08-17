function [Zhat,score] = inferLatentVariable(params, model, X, Y)
%CONSTRAINCB Summary of this function goes here
%  compute the augmented inference problem
%  zi = argmax_z(psi(xi,yi,z;w)) where psi(xi,yi,z;w) = <w,phi(xi,yi,z)>
%  psi(x,y,z;w) is a graph model and psi is the feature vector
%  the argmax is computed by MAP inference using libDAI

assert(length(model.w) == params.dimension)
assert(iscolumn(X))
assert(iscolumn(Y))

% build graphical model: factors that violate observed Y are set to zero
factors = build_graphical_factors(X,params,model,Y);

% argmax_z <phi(x,y,z), w>
[YZhat,score] = RunInference(factors);
[Yhat,Zhat] = ind2subYZ(params,YZhat);

Zhat = Zhat(:);

assert(isequal(Y,Yhat(:)));

end