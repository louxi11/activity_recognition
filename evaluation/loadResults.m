numStateZ = 1;
C = 0.3;
E = 0.25;
W = 3;
tfeat = 'tfeat_on';
thres = 1;
initStrategy = 'clustering';
iter = 3;

Z1 = [];
for corruptPercentage = 0:0.1:0.9
  filebase = sprintf('Z%d_cp_%.2f_C%.2f_E%.2f_W%d_%s_Thre%.1f_%s_iter%d.mat',numStateZ,corruptPercentage,C,E,W,tfeat,thres,initStrategy,iter);
  if exist(filebase, 'file') 
    load(filebase)
%     fscore = 2*prec.*recall./(prec+recall);
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
%     fscore = 2*prec.*recall./(prec+recall);
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
%     fscore = 2*prec.*recall./(prec+recall);
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
%     fscore = 2*prec.*recall./(prec+recall);
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

numStateZ = 1;
multi = [];
for corruptPercentage = 0:0.1:0.9
  filebase = sprintf('MultiClass_Z%d_cp_%.2f_C%.2f_E%.2f_W%d_%s_Thre%.1f_%s_iter%d.mat',numStateZ,corruptPercentage,C,E,W,tfeat,thres,initStrategy,iter);
  if exist(filebase, 'file')
    load(filebase)
%     fscore = 2*prec.*recall./(prec+recall);
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
  multi = [multi;[m,p,r,a]];
end

figure(1)
hold off
plot([0.1,1],[0.653,0.653],'k--','linewidth',2); hold on;
plot([0.1,1],[0.804,0.804],'k-.','linewidth',2)
plot(0.1:0.1:1,Z1(:,1),'r','linewidth',3)
plot(0.1:0.1:1,Z2(:,1),'b','linewidth',3)
plot(0.1:0.1:1,Z3(:,1),'g','linewidth',3)
plot(0.1:0.1:1,Z4(:,1),'m','linewidth',3)


set(gca,'XTickLabel',100:-10:10)
axis([0.1,1,0,1])
xlabel('Percentage of Labeled Data (%)','fontsize',13)
ylabel('F1-score','fontsize',13)
h1 = legend('Multi-class SVM','Koppula et al.','Semi. Latent-1','Semi. Latent-2','Semi. Latent-3','Semi. Latent-4');
%%
figure(2)
hold off
plot(0.1:0.1:1,Z1(:,4),'r','linewidth',3)
hold on
plot(0.1:0.1:1,Z2(:,4),'b','linewidth',3)
plot(0.1:0.1:1,Z3(:,4),'g','linewidth',3)
plot(0.1:0.1:1,Z4(:,4),'m','linewidth',3)


set(gca,'XTickLabel',100:-10:10)
axis([0.1,1,0,1])
xlabel('Percentage of Labeled Data (%)','fontsize',13)
ylabel('Classification Rate','fontsize',13)
h2 = legend('Semi. Latent-1','Semi. Latent-2','Semi. Latent-3','Semi. Latent-4');

[Z1(:,4)';Z2(:,4)';Z3(:,4)';Z4(:,4)']

%% SV
SV = importdata('SV.txt');
SV = SV.data;
SV = reshape(SV,12,length(SV)/12);
SV1 = mean(SV(:,1:10));
SV2 = mean(SV(:,11:20));
SV3 = mean(SV(:,21:30));
SV4 = mean(SV(:,31:40));

figure(3)
hold off
plot(0.1:0.1:1,SV1,'r','linewidth',3)
hold on
plot(0.1:0.1:1,SV2,'b','linewidth',3)
plot(0.1:0.1:1,SV3,'g','linewidth',3)
plot(0.1:0.1:1,SV4,'m','linewidth',3)

set(gca,'XTickLabel',100:-10:10)
axis([0.1,1,0,90])
xlabel('Percentage of Labeled Data (%)','FontSize',13)
ylabel('Average Number of Support Vectors','FontSize',13)
legend('Semi. Latent-1','Semi. Latent-2','Semi. Latent-3','Semi. Latent-4');

%% Iter
Iter = importdata('Iter.txt');
Iter = Iter.data;
Iter = reshape(Iter,12,length(Iter)/12);
Iter(Iter<2)=2;
Iter(:,1) = 1;
Iter1 = mean(Iter(:,1:10));
Iter2 = mean(Iter(:,11:20));
Iter3 = mean(Iter(:,21:30));
Iter4 = mean(Iter(:,31:40));

figure(4)
hold off
% plot([0.1,1],[1,1],'r','linewidth',3)
plot(0.1:0.1:1,Iter1,'r','linewidth',3)
hold on
plot(0.1:0.1:1,Iter2,'b','linewidth',3)
plot(0.1:0.1:1,Iter3,'g','linewidth',3)
plot(0.1:0.1:1,Iter4,'m','linewidth',3)

% axis([0.1,1,0,5.5])
set(gca,'XTickLabel',100:-10:10)
xlabel('Percentage of Labeled Data (%)','FontSize',13)
ylabel('Average number of CCCP iterations','FontSize',13)
h2 = legend('Semi. Latent-1','Semi. Latent-2','Semi. Latent-3','Semi. Latent-4');

%% CCCP Runtime
runtime = importdata('runtime.txt');
runtime = runtime.data;
runtime = reshape(runtime,12,length(runtime)/12);
runtime(runtime<2)=2;
runtime1 = mean(runtime(:,1:10));
runtime2 = mean(runtime(:,11:20));
runtime3 = mean(runtime(:,21:30));
runtime4 = mean(runtime(:,31:40));
figure(5)
hold off
plot(0.1:0.1:1,runtime1,'r','linewidth',3)
hold on
plot(0.1:0.1:1,runtime2,'b','linewidth',3)
plot(0.1:0.1:1,runtime3,'g','linewidth',3)
plot(0.1:0.1:1,runtime4,'m','linewidth',3)

set(gca,'XTickLabel',100:-10:10)
xlabel('Percentage of Labeled Data (%)','FontSize',13)
ylabel('CPU Runtime per CCCP iteraction (seconds)','FontSize',13)
h3 = legend('Semi. Latent-1','Semi. Latent-2','Semi. Latent-3','Semi. Latent-4');

%% Total training time
runtime = importdata('runtime.txt');
runtime = runtime.data;
runtime = reshape(runtime,12,length(runtime)/12);
runtime(runtime<2)=2;
runtime1 = mean(runtime(:,1:10));
runtime2 = mean(runtime(:,11:20));
runtime3 = mean(runtime(:,21:30));
runtime4 = mean(runtime(:,31:40));
figure(5)
hold off
plot(0.1:0.1:1,runtime1.*Iter1,'r-*','linewidth',3)
hold on
plot(0.1:0.1:1,runtime2.*Iter2,'b-*','linewidth',3)
plot(0.1:0.1:1,runtime3.*Iter3,'g-*','linewidth',3)
plot(0.1:0.1:1,runtime4.*Iter4,'m-*','linewidth',3)

set(gca,'XTickLabel',100:-10:10)
xlabel('Percentage of Labeled Data (%)','FontSize',13)
ylabel('Training time (seconds)','FontSize',13)
h3 = legend('Semi. Latent-1','Semi. Latent-2','Semi. Latent-3','Semi. Latent-4');

%% AUC
AUC_Z1 = trapz(0.1:0.1:1,Z1) / trapz(0.1:0.1:1,ones(10,1));
AUC_Z2 = trapz(0.1:0.1:1,Z2) / trapz(0.1:0.1:1,ones(10,1));
AUC_Z3 = trapz(0.1:0.1:1,Z3) / trapz(0.1:0.1:1,ones(10,1));
AUC_Z4 = trapz(0.1:0.1:1,Z4) / trapz(0.1:0.1:1,ones(10,1));
[AUC_Z1;AUC_Z2;AUC_Z3;AUC_Z4]