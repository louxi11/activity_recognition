mkdir CAD120
cd CAD120

# download dynamic segments
wget -nc http://basterwijn.nl/ninghang/data/CAD120/segmentation_features.tgz
tar -xvzf segmentation_features.tgz

# download ground-truth segments
cd segmentation_features
wget -nc http://pr.cs.cornell.edu/humanactivities/data/features.tar
mkdir groundtruth
tar -xvf features.tar -C groundtruth --strip-components=1
cd groundtruth
tar -xvzf features_binary_svm_format.tar.gz --strip-components=1
tar -xvzf segments_svm_format.tar.gz
cd ../../

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

echo ALL DONE
# use groundtruth
#cp groundtruth/segments_svm_format/* ../segmentation_lists/groundtruth/
#p=`pwd`/groundtruth
#sed -i "s:path_to_file:$p:g" ../segmentation_lists/groundtruth/*.txt

