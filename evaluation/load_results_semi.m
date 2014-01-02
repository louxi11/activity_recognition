% function loadResults

close all

BaseFolder = 'results_semi_supervised';

flipProb = 0;
options = 'corrupt'; % flip | corrupt
C = 0.3;
E = 0.4;
initStrategy = 'learning';
flipProbSet = 0 : 0.1 : 1;
StateZSet = 1 : 8;

tfeat = 'tfeat_on';
thres = 1;
W = 3;

baseFiles = {'groundtruth' ...
  'uniform_20_0' 'uniform_20_15' 'uniform_30_10' 'uniform_40_10' ...
  'm1_100' 'm1_500' 'm1_1000' 'm2_100' 'm2_500' 'm2_1000'};

ACCURACY_CURVE = nan(length(flipProbSet),length(baseFiles));

for j = 1 : length(flipProbSet)
  
  flipProb = flipProbSet(j);
  
  FSCORE = nan(8,length(baseFiles));
  ACCURACY = nan(8,length(baseFiles));
  PRECISION = nan(8,length(baseFiles));
  RECALL = nan(8,length(baseFiles));
  
  for i = 1 : length(baseFiles)
    
    baseFile = baseFiles{i};
    
    dirResults = sprintf('opt_%s_Prob_%.2f_%s_C%.2f_E%.2f_W%d_%s_Thre%.1f_%s',...
      options,flipProb,baseFile,C,E,W,tfeat,thres,initStrategy);
    
    for numStateZ = 1 : 8
      if numStateZ > 1
        iter = 3;
      else
        iter = 1;
      end
      
      fscore = [];
      testRate = [];
      prec = [];
      recall = [];
      
      while iter > 0
        filebase = sprintf('%s_Z%d_C%.2f_E%.2f_W%d_%s_Thre%.1f_%s_iter%d',...
          baseFile,numStateZ,C,E,W,tfeat,thres,initStrategy,iter);
        file = fullfile(BaseFolder,dirResults,[filebase,'.mat']);
        if exist(file, 'file')
          load(file)
          FSCORE(numStateZ,i) = mean2(fscore(:,1:iter));
          ACCURACY(numStateZ,i) = mean2(testRate(:,1:iter));
          PRECISION(numStateZ,i) = mean2(prec(:,1:iter));
          RECALL(numStateZ,i) = mean2(recall(:,1:iter));
          break;
        else
          iter = iter - 1;
        end
        if iter == 0
          FSCORE(numStateZ,i) = nan;
          ACCURACY(numStateZ,i) = nan;
          PRECISION(numStateZ,i) = nan;
          RECALL(numStateZ,i) = nan;
          warning([file,' not exist'])
        end
        
      end
      
    end
    
  end
% flipProb*10+1
  ACCURACY_CURVE(int32(flipProb*10+1),:) = max(ACCURACY);
  FSCORE_CURVE(int32(flipProb*10+1),:) = max(FSCORE);
end

UniformACC = mean(ACCURACY_CURVE(:,2:5),2);
AutoSegACC = mean(ACCURACY_CURVE(:,6:end),2);
UniformFSCORE = mean(FSCORE_CURVE(:,2:5),2);
AutoSegFSCORE = mean(FSCORE_CURVE(:,6:end),2);

% function loadResults

close all

BaseFolder = 'results_semi_supervised';

flipProb = 0;
options = 'flip'; % flip | corrupt
C = 0.3;
E = 0.4;
initStrategy = 'learning';
flipProbSet = 0 : 0.1 : 1;
StateZSet = 1 : 8;

tfeat = 'tfeat_on';
thres = 1;
W = 3;

baseFiles = {'groundtruth' ...
  'uniform_20_0' 'uniform_20_15' 'uniform_30_10' 'uniform_40_10' ...
  'm1_100' 'm1_500' 'm1_1000' 'm2_100' 'm2_500' 'm2_1000'};

ACCURACY_CURVE = nan(length(flipProbSet),length(baseFiles));

for j = 1 : length(flipProbSet)
  
  flipProb = flipProbSet(j);
  
  FSCORE = nan(8,length(baseFiles));
  ACCURACY = nan(8,length(baseFiles));
  PRECISION = nan(8,length(baseFiles));
  RECALL = nan(8,length(baseFiles));
  
  for i = 1 : length(baseFiles)
    
    baseFile = baseFiles{i};
    
    dirResults = sprintf('opt_%s_Prob_%.2f_%s_C%.2f_E%.2f_W%d_%s_Thre%.1f_%s',...
      options,flipProb,baseFile,C,E,W,tfeat,thres,initStrategy);
    
    for numStateZ = 1 : 8
      if numStateZ > 1
        iter = 3;
      else
        iter = 1;
      end
      
      fscore = [];
      testRate = [];
      prec = [];
      recall = [];
      
      while iter > 0
        filebase = sprintf('%s_Z%d_C%.2f_E%.2f_W%d_%s_Thre%.1f_%s_iter%d',...
          baseFile,numStateZ,C,E,W,tfeat,thres,initStrategy,iter);
        file = fullfile(BaseFolder,dirResults,[filebase,'.mat']);
        if exist(file, 'file')
          load(file)
          FSCORE(numStateZ,i) = mean2(fscore(:,1:iter));
          ACCURACY(numStateZ,i) = mean2(testRate(:,1:iter));
          PRECISION(numStateZ,i) = mean2(prec(:,1:iter));
          RECALL(numStateZ,i) = mean2(recall(:,1:iter));
          break;
        else
          iter = iter - 1;
        end
        if iter == 0
          FSCORE(numStateZ,i) = nan;
          ACCURACY(numStateZ,i) = nan;
          PRECISION(numStateZ,i) = nan;
          RECALL(numStateZ,i) = nan;
          warning([file,' not exist'])
        end
        
      end
      
    end
    
  end
% flipProb*10+1
  ACCURACY_CURVE(int32(flipProb*10+1),:) = max(ACCURACY);
  FSCORE_CURVE(int32(flipProb*10+1),:) = max(FSCORE);
end

UniformACC1 = mean(ACCURACY_CURVE(:,2:5),2);
AutoSegACC1 = mean(ACCURACY_CURVE(:,6:end),2);
UniformFSCORE1 = mean(FSCORE_CURVE(:,2:5),2);
AutoSegFSCORE1 = mean(FSCORE_CURVE(:,6:end),2);

%%
plot(0:0.1:1,AutoSegACC,'r','linewidth',2)
hold on
plot(0:0.1:1,AutoSegACC1,'r--','linewidth',2)
plot(0:0.1:1,UniformACC,'b','linewidth',2)
plot(0:0.1:1,UniformACC1,'b--','linewidth',2)
hold off
axis([0,1,0,0.8])
legend('AutoSeg Semi','AutoSeg ICRA','UniformSeg Semi','UniformSeg ICRA')
xlabel('Probability of noisy labels at transition')
ylabel('Average classfication rate')

%%
figure
plot(0:0.1:1,AutoSegFSCORE,'r','linewidth',2)
hold on
plot(0:0.1:1,AutoSegFSCORE1,'r--','linewidth',2)
plot(0:0.1:1,UniformFSCORE,'b','linewidth',2)
plot(0:0.1:1,UniformFSCORE1,'b--','linewidth',2)
hold off
axis([0,1,0,0.8])
legend('AutoSeg Semi','AutoSeg ICRA','UniformSeg Semi','UniformSeg ICRA')
xlabel('Probability of noisy labels at transition')
ylabel('Average classfication rate')

%%
close all
str = BaseFolder;
draw_cm(ACCURACY,baseFiles,1:8,[8,11],[0.6,0.9]);
t = sprintf('%s accuracy',str);
text(6, 9, t, ...
  'VerticalAlignment', 'bottom', ...
  'HorizontalAlignment', 'center');
F = getframe(gcf);
imwrite(F.cdata, [t '.png']);

close all
draw_cm(FSCORE,baseFiles,1:8,[8,11],[0.6,0.9]);
t = sprintf('%s fscore',str);
text(6, 9, t, ...
  'VerticalAlignment', 'bottom', ...
  'HorizontalAlignment', 'center');
F = getframe(gcf);
imwrite(F.cdata, [t '.png']);

close all
draw_cm(PRECISION,baseFiles,1:8,[8,11],[0.6,0.9]);
t = sprintf('%s precision',str);
text(6, 9, t, ...
  'VerticalAlignment', 'bottom', ...
  'HorizontalAlignment', 'center');
F = getframe(gcf);
imwrite(F.cdata, [t '.png']);

close all
draw_cm(RECALL,baseFiles,1:8,[8,11],[0.6,0.9]);
t = sprintf('%s recall',str);
text(6, 9, t, ...
  'VerticalAlignment', 'bottom', ...
  'HorizontalAlignment', 'center');
F = getframe(gcf);
imwrite(F.cdata, [t '.png']);

%%
% Z1 = [];
%   filebase = sprintf('Z%d_cp_%.2f_C%.2f_E%.2f_W%d_%s_Thre%.1f_%s_iter%d.mat',numStateZ,corruptPercentage,C,E,W,tfeat,thres,initStrategy,iter);
%   if exist(filebase, 'file') 
%     load(filebase)
% %     fscore = 2*prec.*recall./(prec+recall);
%     m = nanmean(fscore(:));
%     p = nanmean(prec(:));     
%     r = nanmean(recall(:));
%     a = results.meanTest;
%   else
%     m = nan;
%     p = nan;
%     r = nan;
%     a = nan;
%   end
%   Z1 = [Z1;[m,p,r,a]];
% end
% 
% 
% 
% figure(1)
% hold off
% plot([0.1,1],[0.653,0.653],'k--','linewidth',2); hold on;
% plot([0.1,1],[0.804,0.804],'k-.','linewidth',2)
% plot(0.1:0.1:1,Z1(:,1),'r','linewidth',3)
% plot(0.1:0.1:1,Z2(:,1),'b','linewidth',3)
% plot(0.1:0.1:1,Z3(:,1),'g','linewidth',3)
% plot(0.1:0.1:1,Z4(:,1),'m','linewidth',3)
% 
% 
% set(gca,'XTickLabel',100:-10:10)
% axis([0.1,1,0,1])
% xlabel('Percentage of Labeled Data (%)','fontsize',13)
% ylabel('F1-score','fontsize',13)
% h1 = legend('Multi-class SVM','Koppula et al.','Semi. Latent-1','Semi. Latent-2','Semi. Latent-3','Semi. Latent-4');
% %%
% figure(2)
% hold off
% plot(0.1:0.1:1,Z1(:,4),'r','linewidth',3)
% hold on
% plot(0.1:0.1:1,Z2(:,4),'b','linewidth',3)
% plot(0.1:0.1:1,Z3(:,4),'g','linewidth',3)
% plot(0.1:0.1:1,Z4(:,4),'m','linewidth',3)
% 
% 
% set(gca,'XTickLabel',100:-10:10)
% axis([0.1,1,0,1])
% xlabel('Percentage of Labeled Data (%)','fontsize',13)
% ylabel('Classification Rate','fontsize',13)
% h2 = legend('Semi. Latent-1','Semi. Latent-2','Semi. Latent-3','Semi. Latent-4');
% 
% [Z1(:,4)';Z2(:,4)';Z3(:,4)';Z4(:,4)']
% 
% %% SV
% SV = importdata('SV.txt');
% SV = SV.data;
% SV = reshape(SV,12,length(SV)/12);
% SV1 = mean(SV(:,1:10));
% SV2 = mean(SV(:,11:20));
% SV3 = mean(SV(:,21:30));
% SV4 = mean(SV(:,31:40));
% 
% figure(3)
% hold off
% plot(0.1:0.1:1,SV1,'r','linewidth',3)
% hold on
% plot(0.1:0.1:1,SV2,'b','linewidth',3)
% plot(0.1:0.1:1,SV3,'g','linewidth',3)
% plot(0.1:0.1:1,SV4,'m','linewidth',3)
% 
% set(gca,'XTickLabel',100:-10:10)
% axis([0.1,1,0,90])
% xlabel('Percentage of Labeled Data (%)','FontSize',13)
% ylabel('Average Number of Support Vectors','FontSize',13)
% legend('Semi. Latent-1','Semi. Latent-2','Semi. Latent-3','Semi. Latent-4');
% 
% %% Iter
% Iter = importdata('Iter.txt');
% Iter = Iter.data;
% Iter = reshape(Iter,12,length(Iter)/12);
% Iter(Iter<2)=2;
% Iter(:,1) = 1;
% Iter1 = mean(Iter(:,1:10));
% Iter2 = mean(Iter(:,11:20));
% Iter3 = mean(Iter(:,21:30));
% Iter4 = mean(Iter(:,31:40));
% 
% figure(4)
% hold off
% % plot([0.1,1],[1,1],'r','linewidth',3)
% plot(0.1:0.1:1,Iter1,'r','linewidth',3)
% hold on
% plot(0.1:0.1:1,Iter2,'b','linewidth',3)
% plot(0.1:0.1:1,Iter3,'g','linewidth',3)
% plot(0.1:0.1:1,Iter4,'m','linewidth',3)
% 
% % axis([0.1,1,0,5.5])
% set(gca,'XTickLabel',100:-10:10)
% xlabel('Percentage of Labeled Data (%)','FontSize',13)
% ylabel('Average number of CCCP iterations','FontSize',13)
% h2 = legend('Semi. Latent-1','Semi. Latent-2','Semi. Latent-3','Semi. Latent-4');
% 
% %% CCCP Runtime
% runtime = importdata('runtime.txt');
% runtime = runtime.data;
% runtime = reshape(runtime,12,length(runtime)/12);
% runtime(runtime<2)=2;
% runtime1 = mean(runtime(:,1:10));
% runtime2 = mean(runtime(:,11:20));
% runtime3 = mean(runtime(:,21:30));
% runtime4 = mean(runtime(:,31:40));
% figure(5)
% hold off
% plot(0.1:0.1:1,runtime1,'r','linewidth',3)
% hold on
% plot(0.1:0.1:1,runtime2,'b','linewidth',3)
% plot(0.1:0.1:1,runtime3,'g','linewidth',3)
% plot(0.1:0.1:1,runtime4,'m','linewidth',3)
% 
% set(gca,'XTickLabel',100:-10:10)
% xlabel('Percentage of Labeled Data (%)','FontSize',13)
% ylabel('CPU Runtime per CCCP iteraction (seconds)','FontSize',13)
% h3 = legend('Semi. Latent-1','Semi. Latent-2','Semi. Latent-3','Semi. Latent-4');
% 
% %% Total training time
% runtime = importdata('runtime.txt');
% runtime = runtime.data;
% runtime = reshape(runtime,12,length(runtime)/12);
% runtime(runtime<2)=2;
% runtime1 = mean(runtime(:,1:10));
% runtime2 = mean(runtime(:,11:20));
% runtime3 = mean(runtime(:,21:30));
% runtime4 = mean(runtime(:,31:40));
% figure(5)
% hold off
% plot(0.1:0.1:1,runtime1.*Iter1,'r-*','linewidth',3)
% hold on
% plot(0.1:0.1:1,runtime2.*Iter2,'b-*','linewidth',3)
% plot(0.1:0.1:1,runtime3.*Iter3,'g-*','linewidth',3)
% plot(0.1:0.1:1,runtime4.*Iter4,'m-*','linewidth',3)
% 
% set(gca,'XTickLabel',100:-10:10)
% xlabel('Percentage of Labeled Data (%)','FontSize',13)
% ylabel('Training time (seconds)','FontSize',13)
% h3 = legend('Semi. Latent-1','Semi. Latent-2','Semi. Latent-3','Semi. Latent-4');
% 
% %% AUC
% AUC_Z1 = trapz(0.1:0.1:1,Z1) / trapz(0.1:0.1:1,ones(10,1));
% AUC_Z2 = trapz(0.1:0.1:1,Z2) / trapz(0.1:0.1:1,ones(10,1));
% AUC_Z3 = trapz(0.1:0.1:1,Z3) / trapz(0.1:0.1:1,ones(10,1));
% AUC_Z4 = trapz(0.1:0.1:1,Z4) / trapz(0.1:0.1:1,ones(10,1));
% [AUC_Z1;AUC_Z2;AUC_Z3;AUC_Z4]