thres=1
isparallel=false
E=0.4
C=0.3

numCores=4
mkdir -p jobs
cd jobs
rm -f job*

declare -a all_baseFile=(m1_100 m1_500 m1_1000 m2_100 m2_500 m2_1000 uniform_20_0 uniform_20_10 uniform_20_15 uniform_30_10 uniform_40_10)
declare -a all_options=(corrupt flip)

for flipProb in $(seq 0 0.1 1)
do
    for baseFile in ${all_baseFile[@]}
    do
        for options in ${all_options[@]}
        do
            for numStateZ in {1..2}
            do
                wt=$(($numStateZ * 5))
                echo "#PBS -lnodes=1:ppn=8" > ./job\_$baseFile\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
                echo "#PBS -lwalltime=$wt:00:00" >> ./job\_$baseFile\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
                echo "module load mcr" >> ./job\_$baseFile\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
                echo "export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:\$LD_LIBRARY_PATH" >> ./job\_$baseFile\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
                echo "cd ~/workspace/activity_recognition" >> ./job\_$baseFile\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
                echo "./semi_supervised_template $numStateZ $C $E $thres $baseFile $isparallel $options $flipProb $numCores" >> ./job\_$baseFile\_E$E\_C$C\_Z$numStateZ\_options$options\_flipProb$flipProb
            done
        done
    done
done
