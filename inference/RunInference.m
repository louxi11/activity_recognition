function [pred,score] = RunInference (factors)

fg = cell(size(factors));

for i = 1 : length(factors)

  fg{i}.Member = factors(i).var;
  if length(factors(i).var) == 1
    % if only one var, column vector
    sz = [factors(i).card,1]; 
  else
    % if multiple vars, size(P) = cardinality
    sz = factors(i).card;
  end
  fg{i}.P = reshape(factors(i).val, sz); 
  
%   % TODO better performance on precision?
%   fg{i}.P = reshape(roundn(factors(i).val,-7), sz);
    
end

[pred,score] = doinference(fg);

end