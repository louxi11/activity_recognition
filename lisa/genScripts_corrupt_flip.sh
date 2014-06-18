thres=1
E=0.4
C=0.3

numCores=1
mkdir -p jobs
cd jobs
rm -f job*

declare -a all_baseFile=(m1_100 m1_500 m1_1000 m2_100 m2_500 m2_1000 uniform_20_0 uniform_20_10 uniform_20_15 uniform_30_10 uniform_40_10)
declare -a all_options=(corrupt flip)

for flipProb in $(seq 0 0.1 1)
do
    for options in ${all_options[@]}
    do
        for numStateZ in 1 2 4 6 8 10 12 14
        do
            wt=$(($numStateZ * 7))
            echo "#PBS -lnodes=1:ppn=12" > ./job\_data1\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
            echo "#PBS -lwalltime=$wt:00:00" >> ./job\_data1\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
            echo "module load mcr" >> ./job\_data1\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
            echo "export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:\$LD_LIBRARY_PATH" >> ./job\_data1\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
            echo "cd ~/workspace/activity_recognition" >> ./job\_data1\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
            for baseFile in ${all_baseFile[@]:0:6}
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
            for baseFile in ${all_baseFile[@]:6:11}
            do
                echo "./activity_recognition_demo $numStateZ $C $E $thres $baseFile $options $flipProb $numCores &" >> ./job\_data2\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
            done
            echo "wait" >> ./job\_data2\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
        done
    done
done
