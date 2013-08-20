function [trainData,testData] = load_CAD120(parse)

if parse
    cd test_data/CAD120/
    parse_CAD120
    cd ../../
end

load test_data/CAD120/CAD120.mat

trainidx = 1:110; % TODO change back
testidx = 111:125;

trainData.patterns = X(trainidx); 
trainData.labels = Y(trainidx);

testData.patterns = X(testidx);
testData.labels = Y(testidx);

end