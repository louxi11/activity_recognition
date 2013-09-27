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
    p = nanmean(prec(:));     
    r = nanmean(recall(:));
    a = results.meanTest;
  else
    m = nan;
    p = nan;
    r = nan;
    a = nan;
  end
  Z1 = [Z1;[m,p,r,a]];
end

numStateZ = 2;
Z2 = [];
for corruptPercentage = 0:0.1:0.9
  filebase = sprintf('Z%d_cp_%.2f_C%.2f_E%.2f_W%d_%s_Thre%.1f_%s_iter%d.mat',numStateZ,corruptPercentage,C,E,W,tfeat,thres,initStrategy,iter);
  if exist(filebase, 'file') 
    load(filebase)
    fscore = 2*prec.*recall./(prec+recall);
    m = nanmean(fscore(:));
    p = nanmean(prec(:));     
    r = nanmean(recall(:));
    a = results.meanTest;
  else
    m = nan;
    p = nan;
    r = nan;
    a = nan;
  end
  Z2 = [Z2;[m,p,r,a]];
end

numStateZ = 3;

C = 0.3;
E = 0.25;
W = 3;
tfeat = 'tfeat_on';
thres = 1;
initStrategy = 'clustering';
iter = 3;

Z3 = [];
for corruptPercentage = 0:0.1:0.9
  filebase = sprintf('Z%d_cp_%.2f_C%.2f_E%.2f_W%d_%s_Thre%.1f_%s_iter%d.mat',numStateZ,corruptPercentage,C,E,W,tfeat,thres,initStrategy,iter);
  if exist(filebase, 'file')
    load(filebase)
    fscore = 2*prec.*recall./(prec+recall);
    m = nanmean(fscore(:));
    p = nanmean(prec(:));     
    r = nanmean(recall(:));
    a = results.meanTest;
  else
    m = nan;
    p = nan;
    r = nan;
    a = nan;
  end
  Z3 = [Z3;[m,p,r,a]];
end

numStateZ = 4;
Z4 = [];
for corruptPercentage = 0:0.1:0.9
  filebase = sprintf('Z%d_cp_%.2f_C%.2f_E%.2f_W%d_%s_Thre%.1f_%s_iter%d.mat',numStateZ,corruptPercentage,C,E,W,tfeat,thres,initStrategy,iter);
  if exist(filebase, 'file')
    load(filebase)
    fscore = 2*prec.*recall./(prec+recall);
    m = nanmean(fscore(:));
    p = nanmean(prec(:));     
    r = nanmean(recall(:));
    a = results.meanTest;
  else
    m = nan;
    p = nan;
    r = nan;
    a = nan;
  end
  Z4 = [Z4;[m,p,r,a]];
end

figure(1)
hold off
plot(0.1:0.1:1,Z1(:,1),'linewidth',3)
hold on
plot(0.1:0.1:1,Z2(:,1),'r','linewidth',3)
plot(0.1:0.1:1,Z3(:,1),'g','linewidth',3)
plot(0.1:0.1:1,Z4(:,1),'m','linewidth',3)

set(gca,'XTickLabel',100:-10:10,'FontSize',12)
axis([0.1,1,0,1])
xlabel('Percentage of Labeled Data (%)','FontSize',12)
ylabel('F1-score','FontSize',12)
legend('Z1','Z2','Z3','Z4')

figure(2)
hold off
plot(0.1:0.1:1,Z1(:,3),'linewidth',3)
hold on
plot(0.1:0.1:1,Z2(:,3),'r','linewidth',3)
plot(0.1:0.1:1,Z3(:,3),'g','linewidth',3)
plot(0.1:0.1:1,Z4(:,3),'m','linewidth',3)

set(gca,'XTickLabel',100:-10:10,'FontSize',12)
axis([0.1,1,0,1])
xlabel('Percentage of Labeled Data (%)','FontSize',12)
ylabel('Classification Rate','FontSize',12)
legend('Z1','Z2','Z3','Z4')


%% SV
SV = importdata('SV.txt');
SV = SV.data;
SV = reshape(SV,12,length(SV)/12);
SV1 = mean(SV(:,1:10)-1);
SV2 = mean(SV(:,11:20)-1);
figure(2)
hold off
plot(0.1:0.1:1,SV1,'linewidth',3)
hold on
plot(0.1:0.1:1,SV2,'r','linewidth',3)
% plot(0.1:0.1:1,Z3(:,1),'g','linewidth',3)
% plot(0.1:0.1:1,Z4(:,1),'m','linewidth',3)

set(gca,'XTickLabel',100:-10:10,'FontSize',12)
% axis([0.1,1,0,90])
xlabel('Percentage of Labeled Data (%)','FontSize',12)
ylabel('Number of Support Vectors','FontSize',12)
legend('Z1','Z2','Z3','Z4')

%% Iter
Iter = importdata('Iter.txt');
Iter = Iter.data;
Iter = reshape(Iter,12,length(Iter)/12);
Iter(Iter<2)=2;
SV1 = mean(Iter(:,1:10)-1);
SV2 = mean(Iter(:,11:20)-1);
figure(3)
hold off
plot(0.1:0.1:1,SV1,'linewidth',3)
hold on
plot(0.1:0.1:1,SV2,'r','linewidth',3)
% plot(0.1:0.1:1,Z3(:,1),'g','linewidth',3)
% plot(0.1:0.1:1,Z4(:,1),'m','linewidth',3)

set(gca,'XTickLabel',100:-10:10,'FontSize',12)
xlabel('Percentage of Labeled Data (%)','FontSize',12)
ylabel('CCCP iterations','FontSize',12)
legend('Z1','Z2','Z3','Z4')

%% AUC
AUC_Z1 = trapz(0.1:0.1:1,Z1) / trapz(0.1:0.1:1,ones(10,1));
AUC_Z2 = trapz(0.1:0.1:1,Z2) / trapz(0.1:0.1:1,ones(10,1));
AUC_Z3 = trapz(0.1:0.1:1,Z3) / trapz(0.1:0.1:1,ones(10,1));
AUC_Z4 = trapz(0.1:0.1:1,Z4) / trapz(0.1:0.1:1,ones(10,1));
[AUC_Z1;AUC_Z2;AUC_Z3;AUC_Z4]