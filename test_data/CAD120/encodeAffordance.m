function afford = encodeAffordance(A,numAfford)
% encode object affordance

sz = [numAfford + 1,length(A)];
afford = zeros(prod(sz),1);
A(isnan(A)) = numAfford + 1;
idx = sub2ind(sz,A,1:length(A));
afford(idx) = 1;

end