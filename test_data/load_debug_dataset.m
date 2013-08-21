function [trainData,testData,DimX,numStateY,numStateZ] = load_debug_dataset(opt)

switch opt
    case 1
        % dataset Word Recognition Large
        fprintf('load_word_recognition_data\n')
        [trainData,testData] = load_word_recognition_data;
        DimX = 64;
        numStateY = 26;
        numStateZ = 1;
    case 2
        % dataset Word Recognition for testing factors PGM 7
        fprintf('load_word_recognition_data_factors\n')
        [trainData,testData] = load_word_recognition_data_factors;
        DimX = 64;
        numStateY = 26;
        numStateZ = 1;
    case 3
        % dataset Word Recognition Small
        fprintf('load_word_recognition_small_data\n')
        trainData = load_word_recognition_small_data;
        DimX = 16*8;
        numStateY = 26;
        numStateZ = 1;
    otherwise
        error('load_debug_dataset:unknow option');
end
        
end
