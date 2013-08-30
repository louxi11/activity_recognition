function draw_cm(mat,tickx,ticky,dim)
%
%  Matlab code for visualization of confusion matrix;
%  mat: confusion matrix;
%  tick: name of each class, e.g. 'class_1' 'class_2'...
%  dim: dimension
%
%  Modified by Ninghang Hu on Mar 11, 2013
%  now function accepts non-square matrix

%
assert(size(mat,1)==dim(1));
assert(size(mat,2)==dim(2));
% assert()

imagesc(1:dim(2),1:dim(1),mat);            %# in color
colormap(gray);  %# for gray; black for large value.

textStrings = num2str(mat(:),'%0.3f');  
textStrings = strtrim(cellstr(textStrings)); 
[x,y] = meshgrid(1:dim(2),1:dim(1));
hStrings = text(x(:),y(:),textStrings(:), 'HorizontalAlignment','center','FontSize',10);
midValue = mean(get(gca,'CLim')); 
textColors = repmat(mat(:) < midValue,1,3);
nanIND = isnan(mat(:));
textColors(nanIND,:) = 1;
set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors
set(gca,'xticklabel',tickx,'XAxisLocation','top');
set(gca, 'XTick', 1:dim(2), 'YTick', 1:dim(1));
set(gca,'yticklabel',ticky);
% rotateXLabels(gca, 45 );% rotate the x tick


