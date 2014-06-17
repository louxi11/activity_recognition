function phi = featureCB(params, X, YZ)
%FEATURECB Summary of this function goes here
%   Y and Z must be column vectors
%  compute the feature vectors, which will be used to compute the objective
%  function psi(x,y;w) = <w,phi(x,y)>
%  phi must be sparse column vector

[Y,Z] = splitYZ(params.numStateZ,YZ);
if ~isempty(Z)
  YZcomb = sub2indYZ(params,Y,Z);
else
  YZcomb = Y;
end

% unary features
maskX = find(X);
[indYZ,indXDimension] = meshgrid(YZcomb,1:params.DimX);
A = accumarray([indXDimension(maskX),indYZ(maskX)],full(X(maskX)),[params.DimX,params.numStateYZ],[],[],true);


% prior features
B = accumarray(YZcomb,1,[params.numStateYZ,1],[],[],true);

% transition features P(i->j) at (i,j)
if length(YZcomb) > 1
  C = accumarray([YZcomb(1:end-1),YZcomb(2:end)], 1,...
    [params.numStateYZ,params.numStateYZ],[],[],true);
else
  % set trans features to zeros when sequence contains no transition
%   warning('training sequence only contain ONE observation!');
  C = zeros(params.numStateYZ,params.numStateYZ);
end


% return a sparse vector that has the same dimension as the parameters
phi = [A(:);B;C(:)];

assert(iscolumn(phi))

% if params.verbose
%     fprintf('w = psi([%8.3f,%8.3f], %3d) = [%8.3f, %8.3f]\n', ...
%         x, y, full(phi(1)), full(phi(2))) ;
% end

end