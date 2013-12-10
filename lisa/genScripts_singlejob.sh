thres=1
corruptPercentage=inf
baseFile=uniform_20_10
isparallel=false
E=0.4
C=0.3
options=corrupt
flipProp=0.5
numCores=4
mkdir -p jobs
cd jobs
rm -f job*

for numStateZ in {1..8}
do
    wt=$(($numStateZ * 5))
    echo "#PBS -lnodes=1:ppn=1" > ./job\_$baseFile\_CP$corruptPercentage\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProp$flipProp
    echo "#PBS -lwalltime=$wt:00:00" >> ./job\_$baseFile\_CP$corruptPercentage\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProp$flipProp
    echo "module load mcr" >> ./job\_$baseFile\_CP$corruptPercentage\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProp$flipProp
    echo "export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:\$LD_LIBRARY_PATH" >> ./job\_$baseFile\_CP$corruptPercentage\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProp$flipProp
    echo "cd ~/workspace/activity_recognition" >> ./job\_$baseFile\_CP$corruptPercentage\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProp$flipProp
    echo "./semi_supervised_template $numStateZ $C $E $thres $baseFile $corruptPercentage $isparallel $options $flipProp $numCores" >> ./job\_$baseFile\_CP$corruptPercentage\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProp$flipProp
done
