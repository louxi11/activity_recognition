function results = collect_results(trainRate,testRate,prec,recall,fscore)

% training accuracy
results.meanTrain = mean2(trainRate);
results.stdTrain = std2(trainRate);

% testing accuracy
results.meanTest = mean2(testRate);
results.stdTest = std2(testRate);

% testing precision
results.meanPrec = mean2(prec);
results.stdPrec = std2(prec);

% testing recall
results.meanRecall = mean2(recall);
results.stdRecall = std2(recall);

% testing fscore
results.meanFscore = mean2(fscore);
results.stdFscore = std2(fscore);

results.trainRate = trainRate;
results.testRate = testRate;
results.prec = prec;
results.recall = recall;
results.fscore = fscore;

end