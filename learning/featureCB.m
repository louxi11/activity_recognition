function phi = featureCB(params, X, Y)
%FEATURECB Summary of this function goes here
%   Y and Z must be column vectors
%  compute the feature vectors, which will be used to compute the objective
%  function psi(x,y;w) = <w,phi(x,y)>

Z = ones(size(Y)); % TODO: latent variables

K = length(X) / params.DimX;
X = reshape(X,params.DimX,K);

sz_yz = [params.numStateY,params.numStateZ];

% unary features
A = zeros(params.DimX, params.numStateY * params.numStateZ);
for i = 1 : size(Y, 1)
    A(:,sub2ind(sz_yz,Y(i),Z(i))) = A(:,sub2ind(sz_yz,Y(i),Z(i))) + X(:,i);
end


% prior features
vals = ones(length(Y),1);
B = accumarray([Y,Z],vals,sz_yz);


% transition features P(i->j) at (j,i) TODO: change back
if length(Y) > 1
  vals = ones(length(Y)-1,1);
  C = accumarray([sub2ind(sz_yz,Y(2:end),Z(2:end)),sub2ind(sz_yz,Y(1:end-1),Z(1:end-1))],...
    vals,[prod(sz_yz),prod(sz_yz)]);
else
  C = [];
end


% return a sparse vector that has the same dimension as the parameters
phi = sparse([A(:);B(:);C(:)]);

assert(iscolumn(phi))

% if params.verbose
%     fprintf('w = psi([%8.3f,%8.3f], %3d) = [%8.3f, %8.3f]\n', ...
%         x, y, full(phi(1)), full(phi(2))) ;
% end

end