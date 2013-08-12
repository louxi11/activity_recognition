function [trainDataOut,testDataOut] = load_word_recognition_data_factors

% training data
load test_data/word_recognition/Part2Sample.mat

data.X = sampleX;
data.y = sampleY;

encoded = [];
for o = 1 : size(data.X,1)
  encoded = [encoded,oneOfNendcoding(data.X(o,:))];
end
patterns{1} = encoded';
labels{1} = (data.y)';

trainDataOut.patterns = patterns;
trainDataOut.labels = labels;

% test data
load test_data/word_recognition/Part2Test.mat

data.X = testX;
data.y = testY;

encoded = [];
for o = 1 : size(data.X,1)
  encoded = [encoded,oneOfNendcoding(data.X(o,:))];
end
patterns{1} = encoded';
labels{1} = (data.y)';

testDataOut.patterns = patterns;
testDataOut.labels = labels;

end