function delta = lossCB(params, Y, Ybar)
%LOSSCB Summary of this function goes here
%   Detailed explanation goes here

% the loss function is defined as the number of mis-classified items
delta = sum(double((Y - Ybar) ~= 0)); % TODO classification error instead?
% delta = sum(abs(Y - Ybar)) / length(Y);

end