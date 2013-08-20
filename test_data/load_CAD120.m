function [trainData,testData] = load_CAD120(parse)

if parse
    cd test_data/CAD120/
    parse_CAD120
    cd ../../
end

load test_data/CAD120/CAD120.mat

trainData.patterns = X;
trainData.labels = Y;

testData = [];

end