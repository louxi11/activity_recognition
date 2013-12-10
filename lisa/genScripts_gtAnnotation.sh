thres=1
corruptPercentage=0
#baseFile=m1_100
isparallel=false
E=0.4
C=0.3
options=corrupt
flipThre=3
numCores=4
mkdir -p jobs
cd jobs
rm -f job*

declare -a all_baseFile=(m1_1000 m1_500 m2_100 m2_1000 m2_500 uniform_20_0 uniform_20_15 uniform_30_10 uniform_40_10)
for baseFile in ${all_baseFile[@]}
do
    for numStateZ in {1..8}
    do
        wt=$(($numStateZ * 5))
        echo "#PBS -lnodes=1:ppn=1" > ./job\_$baseFile\_CP$corruptPercentage\_E$E\_C$C\_Z$numStateZ\_options$options\_flipThre$flipThre
        echo "#PBS -lwalltime=$wt:00:00" >> ./job\_$baseFile\_CP$corruptPercentage\_E$E\_C$C\_Z$numStateZ\_options$options\_flipThre$flipThre
        echo "module load mcr" >> ./job\_$baseFile\_CP$corruptPercentage\_E$E\_C$C\_Z$numStateZ\_options$options\_flipThre$flipThre
        echo "export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:\$LD_LIBRARY_PATH" >> ./job\_$baseFile\_CP$corruptPercentage\_E$E\_C$C\_Z$numStateZ\_options$options\_flipThre$flipThre
        echo "cd ~/workspace/activity_recognition" >> ./job\_$baseFile\_CP$corruptPercentage\_E$E\_C$C\_Z$numStateZ\_options$options\_flipThre$flipThre
        echo "./semi_supervised_template $numStateZ $C $E $thres $baseFile $corruptPercentage $isparallel $options $flipThre $numCores" >> ./job\_$baseFile\_CP$corruptPercentage\_E$E\_C$C\_Z$numStateZ\_options$options\_flipThre$flipThre
    done
done
