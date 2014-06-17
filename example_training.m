% This is an example for training the model of [1,2,3]
%
% 1. Learning to Recognize Human Activities from Soft Labeled Data
%    Ninghang Hu, Zhongyu Lou, Gwenn Englebienne, Ben Kröse
%    Robotics: Science and Systems (RSS), 2014
%
% 2. Learning Latent Structure for Activity Recognition
%    Ninghang Hu, Gwenn Englebienne, Zhongyu Lou, Ben Kröse
%    IEEE International Conference on Robotics and Automation (ICRA), 2014
%
% 3. A Two-layered Approach to Recognize High-level Human Activities
%    Ninghang Hu, Gwenn Englebienne, Ben Kröse
%    IEEE International Symposium on Robot and Human Interactive Communication (RO-MAN), 2014
%
% Following is the parameters that are used to generate the results in [1-3]
%
% soft labeling [1]:  numStateZ: from '1' to '8'
%                     options = 'corrupt'
%                     alterProb = from '0.0' to '1.0' with step size '0.1'
%
% hard labeling [1]:  numStateZ: from '1' to '8'
%                     options = 'flip'
%                     alterProb = from '0.0' to '1.0' with step size '0.1'
%
% latent activity model [2]:  numStateZ: from '1' to '4'
%                             options = 'flip'
%                             alterProb = '0'
%
% recognize high-level activities [3]
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLEASE NOTE THAT ALL PARAMETERS NEEDS TO BE STRING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% latent-SVM parameters
numStateZ = '1';          % number of latent states
C = '0.3';                % normalization constant - SVM parameter
E = '0.4';                % epsilon - SVM parameter
thres = '1';              % threshold to stop CCCP iteration
numCores = '1';           % number of slaves in parrallel computing

% baseFile takes the name of the dataset for evaluation. valid options:
% groundtruth segmentation: 'groundtruth'
% uniform segmentation: 'uniform_20_0' 'uniform_20_15' 'uniform_30_10' 'uniform_40_10'
% graph-based segmentation: 'm1_100' 'm1_500' 'm1_1000' 'm2_100' 'm2_500' 'm2_1000'
baseFile = 'groundtruth';

% options is a flag to switch between [1,2,3]. It can be either 'flip' or 'corrupt'.
% 'flip' corresponds with hard labeling [2]
% 'corrupt' corresponds with soft labeling [1]
% both options will compute the high-level activities, i.e. [3]
options = 'corrupt';

% alterProb defines the amount of noise that is added to the data. When
% alterProb=0, the groundtruth labels are used. When alterProb=0.5, labels at
% the transition segments are either fliped [2] or treated as soft labels [1]
% based on the 'options'.
alterProb = '0';

%
activity_recognition_demo(numStateZ,C,E,thres,baseFile,options,alterProb,numCores);

