%% plot error bar
X = [0.05, 0.25, 0.5, 0.75, 1.5, 2, 3, 4];
hold off
errorbar(X,results.meanTrain,results.stdTrain,'b')
hold on
errorbar(X,results.meanTest,results.stdTest,'r')
hold off
% axis([0,1.1,0.7,1])
xlabel('epsilon')
ylabel('classification rate')