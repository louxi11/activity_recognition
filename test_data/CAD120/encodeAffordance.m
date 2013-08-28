function afford = encodeAffordance(A,numAfford)
% encode object affordance

sz = [numAfford,length(A)];
afford = zeros(sz);
for i = 1 : length(A)
  a = A(i);
  if isnan(a)
    continue
  else 
    afford(a,i) = 1;
  end
end
afford = afford(:);

end