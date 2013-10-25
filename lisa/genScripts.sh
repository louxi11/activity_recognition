thres=7
corruptPercentage=inf
baseFile=m2_500
isparallel=true

mkdir -p jobs
cd jobs
rm -f job*

for E in 0.2 0.4 0.6 0.8 1.0 1.3 1.6 2.0 2.5 3.0
do
    for C in 0.2 0.4 0.6 0.8 1.0 1.3 1.6 2.0 2.5 3.0
    do
        for numStateZ in {1..4}
        do
            echo "#PBS -lnodes=1:ppn=1" > ./job_E$E\_C$C\_Z$numStateZ
            echo "#PBS -lwalltime=100:00:00" >> ./job_E$E\_C$C\_Z$numStateZ
            echo "module load mcr" >> ./job_E$E\_C$C\_Z$numStateZ
            echo "cd ~/workspace/activity_recognition" >> ./job_E$E\_C$C\_Z$numStateZ
            echo "./semi_supervised_template $numStateZ $C $E $thres $baseFile $corruptPercentage $isparallel" >> ./job_E$E\_C$C\_Z$numStateZ
        done
    done
done