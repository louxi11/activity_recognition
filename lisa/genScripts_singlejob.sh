thres=1
corruptPercentage=inf
baseFile=uniform_20_10
isparallel=false
E=0.4
C=0.3
options=corrupt
flipThre=3
numCores=4
mkdir -p jobs
cd jobs
rm -f job*

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
