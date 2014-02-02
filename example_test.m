set_global_path;
baseFile = 'groundtruth'; % dataset to evaluate

% load model
load('model_groundtruth_Z2_C0.30_E0.25_W3_tfeat_on_Thre1.0_learning_iter1_Test4.mat')

% load data
baseFolder = fullfile(pwd,'CAD120','segmentation_lists');
path = fullfile(baseFolder,baseFile);
[trainData,testData] = load_CAD120('tfeat_on',train_sid,path);

% evaluate on training data
[~,~,trainRate] = evaluate_model(trainData, model, params);

% evaluate on test data
[gt_labels,pred_labels,testRate] = evaluate_model(testData, model, params);
[confmat, precision, recall, fscore] = prec_recall(gt_labels,pred_labels);

activity_labels = {'reaching','moving','pouring','eating','drinking','opening','placing','closing','scrubbing','null'};
draw_cm(confmat,activity_labels,activity_labels,[10,10]);