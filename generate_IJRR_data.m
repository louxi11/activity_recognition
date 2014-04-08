% '/home/ninghang/workspace/activity_recognition/CAD120/segmentation_lists/uniform_20_15/'
files = {'m1_100'  'm1_1000'  'm1_500'  'm2_100'  'm2_1000'  'm2_500'  'uniform_20_0'  'uniform_20_10'  'uniform_20_15'  'uniform_30_10'  'uniform_40_10'};

tid = 1;
f = 1;

for tid = 1 : 4
  for f = 1 : length(files)
    baseFile = files{f};
    baseFolder = fullfile(pwd,'CAD120','segmentation_lists');
    path = fullfile(baseFolder,baseFile);
    combos = combntns(1:4,3);
    tfeat = 'tfeat_on';
    train_sid = combos(tid,:);
    [trainData,testData] = load_CAD120(tfeat,train_sid,path);
    
    
    % write training data list to file
    fileID = fopen(sprintf('training_%s_cv%d.txt',baseFile,tid),'w');
    for i = 1 : length(trainData.vidID)
      filepath = fullfile(...
        '/home/ninghang/workspace/activity_recognition/CAD120/segmentation_lists',...
        baseFile,sprintf('%010d.txt\n',trainData.vidID(i)));
      assert(exist(filepath(1:end-1),'file') ~= 0)
      fprintf(fileID,filepath);
    end
    fclose(fileID);
    
    % write test data list to file
    fileID = fopen(sprintf('test_%s_cv%d.txt',baseFile,tid),'w');
    for i = 1 : length(testData.vidID)
      filepath = fullfile(...
        '/home/ninghang/workspace/activity_recognition/CAD120/segmentation_lists',...
        baseFile,sprintf('%010d.txt\n',testData.vidID(i)));
      assert(exist(filepath(1:end-1),'file') ~= 0)
      fprintf(fileID,filepath);
    end
    fclose(fileID);
  end
end
    