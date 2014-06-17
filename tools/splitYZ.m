function [Y,Z] = splitYZ(numStateZ,YZ)

if numStateZ > 1
  K = length(YZ) / 2;
  Y = YZ(1:K);
  Z = YZ(K+1:end);
else
  Y = YZ;
  Z = [];
end

end
