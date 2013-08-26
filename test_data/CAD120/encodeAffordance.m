function afford = encodeAffordance(A,numAfford)
% encode object affordance

len = length(de2bi(numAfford));

afford = zeros(len,length(A));
for i = 1 : length(A)
  a_dec = A(i);
  if isnan(a_dec)
    a_dec = 0;
  end
  a_bin = de2bi(a_dec,len);
  afford(:,i) = a_bin(:);
end

afford = afford(:);

end