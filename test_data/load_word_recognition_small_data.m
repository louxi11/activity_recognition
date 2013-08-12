function trainData = load_word_recognition_small_data
  
load test_data/word_recognition_small/PA3Data
load test_data/word_recognition_small/PA3Models
patterns = {};
labels = {};
cha = allWords{1}.img;

for i = 1 : length(allWords)
    word = allWords{i};
    chs = [];
    ls = [];
    for j = 1 : length(word)
        chs = [chs ; word(j).img(:)];
        ls = [ls ; word(j).groundTruth(:)];
    end
    patterns{i} = chs;
    labels{i} = ls;
end

trainData.patterns = patterns;
trainData.labels = labels;

end