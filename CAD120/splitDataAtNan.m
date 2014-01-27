function newdata = splitDataAtNan(data)

Y = data.labels;
X = data.patterns;
dim = data.DimX;
len = length(Y);

labels = [];
patterns = [];

for i = 1 : len
  x = X{i};
  y = Y{i};
  K = length(x) / dim;
  x = reshape(x,dim,K);
  
  % Find NaN locations.
  if ~isnan(y(end))
    indx = [0; find(isnan([y(:);nan]))];
  else
    indx = [0; find(isnan(y(:)))];
  end
  
  %  Extract each segment into pre-allocated N-by-1 cell arrays, where N is
  %  the number of polygon segments.  (Add a leading zero to the indx array
  %  to make indexing work for the first segment.)
  N = numel(indx) - 1;
  xx = cell(N,1);
  yy = cell(N,1);
  
  for k = 1:N
    iStart = indx(k)   + 1;
    iEnd   = indx(k+1) - 1;
    temp = x(:,iStart:iEnd);
    xx{k} = temp(:);
    yy{k} = y(iStart:iEnd);
  end
  xx = xx(~cellfun('isempty',xx));
  yy = yy(~cellfun('isempty',yy));
%   len = cellfun(@length,yy);
%   xx(len<2) = []; % removed data that has no transition features TODO
%   yy(len<2) = []; % removed data that has no transition features TODO
  
  patterns = [patterns; xx];
  labels = [labels; yy];
  
end

newdata.labels = labels;
newdata.patterns = patterns;
newdata.DimX = data.DimX;

end