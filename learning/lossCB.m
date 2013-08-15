function delta = lossCB(params, YZ, YZhat)
%LOSSCB Summary of this function goes here
%   get Y and Ybar

[Y,~] = ind2subYZ(params,YZ);
[Yhat,~] = ind2subYZ(params,YZhat);

% the loss function is defined as the number of mis-classified items
delta = double(sum(Y ~= Yhat)); % TODO classification error instead?

end