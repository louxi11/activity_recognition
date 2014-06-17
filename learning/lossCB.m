function delta = lossCB(params, YZ, YZhat)
%LOSSCB Summary of this function goes here
%   get Y and Ybar
% TODO

[Y,~] = splitYZ(params.numStateZ,YZ);
[Yhat,~] = splitYZ(params.numStateZ,YZhat);

% the loss function is defined as the number of mis-classified items
% make sure Y and Yhat is int when comparing
delta = double(sum(int32(Y) ~= int32(Yhat)));

end