function labels = initByAffordance(trainData,params)
% labels is a cell

X = trainData.Affordance;
Y = trainData.labels;
XX = [];
YY = [];
NUM = [];
for i = 1 : length(trainData.patterns)
  x = X{i};
  y = Y{i};
  XX = [XX,x];
  YY = [YY;y];
  NUM = [NUM;length(y)];
end

XX = XX';

% while true
%   try
%     IDX = kmeans(XX,params.numStateZ);
%     break;
%   catch
%     warning('something wrong with kmeans')
%     continue
%   end
% end
  
IDX = kmeans(XX,params.numStateZ,'Replicates',10,'emptyaction','drop');
   

YZ = sub2indYZ(params,YY,IDX);

c = 0;
for i = 1 : length(params.patterns)
    
    labels{i} = YZ(c+1:c+NUM(i));
    c = c+NUM(i);

end

labels = labels';

end
