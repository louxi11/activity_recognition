thres=1
corruptPercentage=inf
baseFile=uniform_20_10
isparallel=false
E=0.25
C=0.3
options=corrupt
flipThre=3

mkdir -p jobs
cd jobs
rm -f job*

for numStateZ in {1..4}
do
    echo "#PBS -lnodes=1:ppn=8" > ./job\_$baseFile\_CP$corruptPercentage\_E$E\_C$C\_Z$numStateZ\_options$options\_flipThre$flipThre
    echo "#PBS -lwalltime=15:00:00" >> ./job\_$baseFile\_CP$corruptPercentage\_E$E\_C$C\_Z$numStateZ\_options$options\_flipThre$flipThre
    echo "module load mcr" >> ./job\_$baseFile\_CP$corruptPercentage\_E$E\_C$C\_Z$numStateZ\_options$options\_flipThre$flipThre
    echo "cd ~/workspace/activity_recognition" >> ./job\_$baseFile\_CP$corruptPercentage\_E$E\_C$C\_Z$numStateZ\_options$options\_flipThre$flipThre
    echo "./semi_supervised_template $numStateZ $C $E $thres $baseFile $corruptPercentage $isparallel $options $flipThre " >> ./job\_$baseFile\_CP$corruptPercentage\_E$E\_C$C\_Z$numStateZ\_options$options\_flipThre$flipThre
done
