function delta = lossCB(params, YZ, YZhat)
%LOSSCB Summary of this function goes here
%   get Y and Ybar
% TODO

[Y,temp] = ind2subYZ(params,YZ);
[Yhat,temp] = ind2subYZ(params,YZhat);

% the loss function is defined as the number of mis-classified items
% make sure Y and Yhat is int when comparing
delta = double(sum(int32(Y) ~= int32(Yhat)));

end