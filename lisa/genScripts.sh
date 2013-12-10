baseFile=uniform_20_10
flipProb=0.5
options=corrupt

thres=1
isparallel=false

numCores=4
mkdir -p jobs
cd jobs
rm -f job*

for E in 0.1 0.25 0.4 0.6 0.8 1.0 1.3 1.6 2.0 2.5 3.0
do
    for C in 0.2 0.3 0.4 0.6 0.8 1.0 1.3 1.6 2.0 2.5 3.0
    do
        for numStateZ in {1..4}
        do
            echo "#PBS -lnodes=1:ppn=1" > ./job\_$baseFile\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
            echo "#PBS -lwalltime=15:00:00" >> ./job\_$baseFile\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
            echo "module load mcr" >> ./job\_$baseFile\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
            echo "export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH" >> ./job\_$baseFile\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
            echo "cd ~/workspace/activity_recognition" >> ./job\_$baseFile\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
            echo "./semi_supervised_template $numStateZ $C $E $thres $baseFile $isparallel $options $flipProb $numCores" >> ./job\_$baseFile\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
        done
    done
done
