mkdir CAD120
cd CAD120
wget -nc http://basterwijn.nl/ninghang/data/CAD120/segmentation_features.tgz
tar -xvzf segmentation_features.tgz
cd segmentation_features
wget -nc http://pr.cs.cornell.edu/humanactivities/data/features.tar
tar -xvf features.tar
cd features_cad120_ground_truth_segmentation
tar -xvzf features_binary_svm_format.tar.gz
mv features_binary_svm_format/* ./
rm -r features_binary_svm_format