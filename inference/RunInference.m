function [pred,score] = RunInference (factors)

fg = cell(size(factors));

for i = 1 : length(factors)

  fg{i}.Member = factors(i).var;
  if length(factors(i).var) == 1
    sz = [factors(i).card,1];
  else
    sz = factors(i).card;
  end
  fg{i}.P = reshape(factors(i).val, sz);
  
end

[pred,score] = doinference(fg);

global count
if ~mod(count,300)
  disp(count)
  disp(pred)
  disp(score)
end
count = count + 1;

end