numStateZ = 1;

C = 0.3;
E = 0.25;
W = 3;
tfeat = 'tfeat_on';
thres = 1;
initStrategy = 'clustering';
iter = 3;

disp('Z1')
Z1 = [];
for corruptPercentage = 0:0.1:0.9
  filebase = sprintf('Z%d_cp_%.2f_C%.2f_E%.2f_W%d_%s_Thre%.1f_%s_iter%d.mat',numStateZ,corruptPercentage,C,E,W,tfeat,thres,initStrategy,iter);
  if exist(filebase, 'file') 
    load(filebase)
    fscore = 2*prec.*recall./(prec+recall);
    m = nanmean(fscore(:));
    s = nanstd(fscore(:));
    a = results.meanTest;
  else
    m = nan;
    s = nan;
    a = nan;
  end
  Z1 = [Z1;[m,s,a]];
end

disp('Z2')
numStateZ = 2;
Z2 = [];
for corruptPercentage = 0:0.1:0.9
  filebase = sprintf('Z%d_cp_%.2f_C%.2f_E%.2f_W%d_%s_Thre%.1f_%s_iter%d.mat',numStateZ,corruptPercentage,C,E,W,tfeat,thres,initStrategy,iter);
  if exist(filebase, 'file') 
    load(filebase)
    fscore = 2*prec.*recall./(prec+recall);
    m = nanmean(fscore(:));
    s = nanstd(fscore(:));
    a = results.meanTest;
  else
    m = nan;
    s = nan;
    a = nan;
  end
  Z2 = [Z2;[m,s,a]];
end

numStateZ = 3;

C = 0.3;
E = 0.25;
W = 3;
tfeat = 'tfeat_on';
thres = 1;
initStrategy = 'clustering';
iter = 3;

disp('Z3')
Z3 = [];
for corruptPercentage = 0:0.1:0.9
  filebase = sprintf('Z%d_cp_%.2f_C%.2f_E%.2f_W%d_%s_Thre%.1f_%s_iter%d.mat',numStateZ,corruptPercentage,C,E,W,tfeat,thres,initStrategy,iter);
  if exist(filebase, 'file')
    load(filebase)
    fscore = 2*prec.*recall./(prec+recall);
    m = nanmean(fscore(:));
    s = nanstd(fscore(:));
    a = results.meanTest;
  else
    m = nan;
    s = nan;
    a = nan;
  end
  Z3 = [Z3;[m,s,a]];
end

disp('Z4')
numStateZ = 4;
Z4 = [];
for corruptPercentage = 0:0.1:0.9
  filebase = sprintf('Z%d_cp_%.2f_C%.2f_E%.2f_W%d_%s_Thre%.1f_%s_iter%d.mat',numStateZ,corruptPercentage,C,E,W,tfeat,thres,initStrategy,iter);
  if exist(filebase, 'file')
    load(filebase)
    fscore = 2*prec.*recall./(prec+recall);
    m = nanmean(fscore(:));
    s = nanstd(fscore(:));
    a = results.meanTest;
  else
    m = nan;
    s = nan;
    a = nan;
  end
  Z4 = [Z4;[m,s,a]];
end

hold off
% errorbar(Z1(:,1),Z1(:,2));
plot(0.1:0.1:1,flipud(Z1(:,1))*100,'linewidth',3)

hold on
% errorbar(Z2(:,1),Z2(:,2),'r')
plot(0.1:0.1:1,flipud(Z2(:,1))*100,'r','linewidth',3)

% errorbar(Z1(:,1),Z1(:,2));
plot(0.1:0.1:1,flipud(Z3(:,1))*100,'g','linewidth',3)

% errorbar(Z2(:,1),Z2(:,2),'r')
plot(0.1:0.1:1,flipud(Z4(:,1))*100,'m','linewidth',3)

axis([0.1,1,0,100])
legend('Z1','Z2','Z3','Z4')