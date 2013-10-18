mkdir CAD120
cd CAD120

# download dynamic segments
wget -nc http://basterwijn.nl/ninghang/data/CAD120/segmentation_features.tgz
tar -xvzf segmentation_features.tgz

# download ground-truth segments
cd segmentation_features
wget -nc http://pr.cs.cornell.edu/humanactivities/data/features.tar
tar -xvf features.tar
cd features_cad120_ground_truth_segmentation
tar -xvzf features_binary_svm_format.tar.gz
mv features_binary_svm_format/* ./
rm -r features_binary_svm_format
cd ../
mv features_cad120_ground_truth_segmentation groundtruth
cd ../

# parse segment names
mkdir segmentation_lists
cd segmentation_features
folders=`ls -d */`
for folder in $folders
do
    cd $folder
    mkdir ../../segmentation_lists/$folder
    ../../../scripts/parseFileName.sh ../../segmentation_lists/$folder
    cd ../
done


