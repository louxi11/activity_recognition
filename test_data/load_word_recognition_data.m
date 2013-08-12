function [trainDataOut,testDataOut] = load_word_recognition_data

% training data
load test_data/word_recognition/Part2FullDataset

for i = 1:length(trainData)
    data = trainData(i);
    encoded = [];
    for o = 1 : size(data.X,1)
%         encoded = [encoded;data.X(o,:)];
        encoded = [encoded,oneOfNendcoding(data.X(o,:))];
    end
    patterns{i} = encoded';
    labels{i} = (data.y)';
end
trainDataOut.patterns = patterns;
trainDataOut.labels = labels;

% test data
load test_data/word_recognition/Part2FullDataset
for i = 1:length(testData)
    data = testData(i);
    encoded = [];
    for o = 1 : size(data.X,1)
%         encoded = [encoded;data.X(o,:)];
        encoded = [encoded,oneOfNendcoding(data.X(o,:))];
    end
    patterns{i} = encoded';
    labels{i} = (data.y)';
end
testDataOut.patterns = patterns;
testDataOut.labels = labels;
