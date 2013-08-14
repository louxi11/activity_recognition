function phi = featureCB(params, X, YZ)
%FEATURECB Summary of this function goes here
%   Y and Z must be column vectors
%  compute the feature vectors, which will be used to compute the objective
%  function psi(x,y;w) = <w,phi(x,y)>
%  phi must be sparse column vector

% K = length(X) / params.DimX; % number of time slices

% unary features
[indYZ,indXDimension] = meshgrid(YZ,1:params.DimX);
A = accumarray([indXDimension(:),indYZ(:)],X,[params.DimX,params.numStateYZ],[],[],true);


% prior features
B = accumarray(YZ,1,[params.numStateYZ,1],[],[],true);


% transition features P(i->j) at (j,i) TODO: change back
if length(YZ) > 1
    C = accumarray([YZ(2:end), YZ(1:end-1)], 1,...
        [params.numStateYZ,params.numStateYZ],[],[],true);
else
    warning('training sequence only contain ONE observation!');
    C = [];
end


% return a sparse vector that has the same dimension as the parameters
phi = [A(:);B;C(:)];

assert(iscolumn(phi))

% if params.verbose
%     fprintf('w = psi([%8.3f,%8.3f], %3d) = [%8.3f, %8.3f]\n', ...
%         x, y, full(phi(1)), full(phi(2))) ;
% end

end