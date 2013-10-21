function label = initFromNeighbor(label,params)

% params.numStateY = 10;

% label = (1:6)';
% label([1,2,4,6]) = nan;

% label

l = label;

% dd=l;

nan_mask = isnan(l);
idx = find(nan_mask);
nan_mask = [false;nan_mask;false];
l = [nan;l;nan];
lidx = [nan_mask(2:end);false];
ridx = [false;nan_mask(1:end-1)];
a = [l(lidx),l(ridx)];

s = sum(isnan(a),2);

% Neigther neighbor is valid -> random label
label(idx(s == 2)) = randsample(params.numStateY,sum(s==2),true);

% one neighbor is valid -> init with valid neighbor
b = a(s == 1,:);
b=b';
label(idx(s == 1)) = b(~isnan(b));

% both neighbors are valid -> init with either of them
c = a(s == 0,:);
if ~isempty(c)
  linIDX = sub2ind(size(c), 1:size(c,1), randi(size(c,2),[1,size(c,1)]));
  label(idx(s == 0)) = c(linIDX);
end

% [dd,label]

end