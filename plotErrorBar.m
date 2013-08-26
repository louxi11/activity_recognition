%% plot error bar
X = [0.05, 0.25, 0.5, 1, 1.5, 2, 3, 4];
hold off
errorbar(X,results.meanTrain,results.stdTrain,'b','LineWidth',2)
hold on
errorbar(X,results.meanTest,results.stdTest,'m','LineWidth',2)
hold off
xlim([0 3.5])
% title('on E')
xlabel('epsilon (N_z=1,C=0.3)')
ylabel('classification rate')

legend('training data','test data')

%% plot error bar
X = [0.01,0.1:0.1:1];
hold off
errorbar(X,[results1.meanTrain,results.meanTrain]...
  ,[results1.stdTrain,results.stdTrain],'b','LineWidth',2)
hold on
errorbar(X,[results1.meanTest,results.meanTest]...
  ,[results1.stdTest,results.stdTest],'m','LineWidth',2)
hold off
axis([-0 1 0.6 1])
% title('on E')
xlabel('C (N_z=1,epsilon=0.5)')
ylabel('classification rate')
set(gca,'XTick',[0.01,0.1:0.1:1])
legend('training data','test data')