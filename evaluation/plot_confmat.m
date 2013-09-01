YY =[];

for y = 1 : length(Y)
  
  YY = [YY;Y{y}];
  
end

activity_labels = {'reaching','moving','pouring','eating','drinking','opening','placing','closing','scrubbing','null'};
p = hist(YY);
p = round(p/sum(p)*100);

for i = 1 : length(activity_labels)
  activity_labels2{i} = sprintf('%s %d%%',activity_labels{i},round(p(i)));
end
pie(normr(p),activity_labels)


%%
close all
m = confusionmat(AllGT,AllPred);
rowsum = sum(m,2);
mat = bsxfun(@rdivide, m, rowsum);
draw_cm(mat,activity_labels,activity_labels,[10,10]);