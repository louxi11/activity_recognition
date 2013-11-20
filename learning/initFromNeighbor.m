function label = initFromNeighbor(label,params)

% label = (1:6)';
% label([2,3,4]) = nan;

% l = label;

idx = find(isnan(label));

if ~isempty(idx)
  lidx = idx;
  ridx = idx;
  lLabel = label(lidx); % nan vector
  rLabel = label(ridx); % nan vector
  
  % find the nearest valid labels
  while sum(isnan(lLabel)) + sum(isnan(rLabel)) > 0
    lidx(isnan(lLabel)) = lidx(isnan(lLabel)) - 1;
    ridx(isnan(rLabel)) = ridx(isnan(rLabel)) + 1;
    lLabel = label(lidx);
    rLabel = label(ridx);
  end
  
  % initialize from nearest valid labels
  len = length(lLabel);
  lrLabels = [lLabel,rLabel];
  randInt = randi(2,len,1);
  linIdx = sub2ind([len,2],1:len,randInt');
  label(idx) = lrLabels(linIdx);
end

% [l,label]

end