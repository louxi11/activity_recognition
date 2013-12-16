baseFile=uniform_20_10
flipProb=0.5
options=corrupt

thres=1
E=0.4
C=0.3

numCores=1
mkdir -p jobs
cd jobs
rm -f job*

for numStateZ in {1..8}
do
    wt=$(($numStateZ * 5))
    echo "#PBS -lnodes=1:ppn=8" > ./job\_$baseFile\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
    echo "#PBS -lwalltime=$wt:00:00" >> ./job\_$baseFile\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
    echo "module load mcr" >> ./job\_$baseFile\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
    echo "export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:\$LD_LIBRARY_PATH" >> ./job\_$baseFile\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
    echo "cd ~/workspace/activity_recognition" >> ./job\_$baseFile\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
    echo "./semi_supervised_template $numStateZ $C $E $thres $baseFile $options $flipProb $numCores" >> ./job\_$baseFile\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
done
