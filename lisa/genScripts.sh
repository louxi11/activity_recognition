thres=1
flipProb=0
options=corrupt

numCores=1
mkdir -p jobs
cd jobs
rm -f job*

declare -a all_baseFile=(groundtruth m1_100 m1_500 m1_1000 m2_100 m2_500 m2_1000 uniform_20_0 uniform_20_10 uniform_20_15 uniform_30_10 uniform_40_10)

for Ei in $(seq -6 0.5 3)
do
    E=`awk "BEGIN {print 2**$Ei}" | awk '{printf "%.2f", $0}'`
    for Ci in $(seq -6 0.5 3)
    do
        C=`awk "BEGIN {print 2**$Ci}" | awk '{printf "%.2f", $0}'`
        for numStateZ in {1..10}
        do
            wt=$(($numStateZ * 7))
            echo "#PBS -lnodes=1:ppn=12" > ./job\_data1\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
            echo "#PBS -lwalltime=$wt:00:00" >> ./job\_data1\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
            echo "module load mcr" >> ./job\_data1\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
            echo "export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:\$LD_LIBRARY_PATH" >> ./job\_data1\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
            echo "cd ~/workspace/activity_recognition" >> ./job\_data1\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
            for baseFile in ${all_baseFile[@]:0:7}
            do
                echo "./activity_recognition_demo $numStateZ $C $E $thres $baseFile $isparallel $options $flipProb $numCores &" >> ./job\_data1\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
            done
            echo "wait" >> ./job\_data1\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb

            wt=$(($numStateZ * 7))
            echo "#PBS -lnodes=1:ppn=12" > ./job\_data2\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
            echo "#PBS -lwalltime=$wt:00:00" >> ./job\_data2\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
            echo "module load mcr" >> ./job\_data2\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
            echo "export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:\$LD_LIBRARY_PATH" >> ./job\_data2\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
            echo "cd ~/workspace/activity_recognition" >> ./job\_data2\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
            for baseFile in ${all_baseFile[@]:7:12}
            do
                echo "./activity_recognition_demo $numStateZ $C $E $thres $baseFile $options $flipProb $numCores &" >> ./job\_data2\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
            done
            echo "wait" >> ./job\_data2\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
        done
    done
done
