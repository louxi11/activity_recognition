function [pred,score] = RunInference (factors)

fg = cell(size(factors));

for i = 1 : length(factors)

  fg{i}.Member = factors(i).var;
  if length(factors(i).var) == 1
    % if only one var, fg.P is a column vector
    sz = [factors(i).card,1]; 
  else
    % if multiple vars, size(fg.P) = variable cardinality
    sz = factors(i).card;
  end
  
  % P value should be a matrix, dimension indicates cardinality
  fg{i}.P = reshape(factors(i).val, sz); 
  
%   % better performance on precision? -> deprecated, not to use
%   fg{i}.P = reshape(roundn(factors(i).val,-7), sz);
    
end

[pred,score] = doinference(fg); % compute the best state sequence and LOG score

pred = double(pred); % convert to double

end