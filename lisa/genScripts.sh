thres=7
corruptPercentage=inf
baseFile=m2_500

mkdir -p jobs
cd jobs
rm -f job*

for E in 0.2 0.4 0.6 0.8 1.0 1.3 1.6 2.0 2.5 3.0
do
    for C in 0.2 0.4 0.6 0.8 1.0 1.3 1.6 2.0 2.5 3.0
    do
        for numStateZ in {1..4}
        do
            echo "#PBS -lnodes=1:ppn=1" > ./job_$E\_$C\_$numStateZ
            echo "#PBS -lwalltime=100:00:00" >> ./job_$E\_$C\_$numStateZ
            echo "module load mcr" >> ./job_$E\_$C\_$numStateZ
            echo "cd ~/workspace/activity_recognition" >> ./job_$E\_$C\_$numStateZ
            echo "./semi_supervised_template $numStateZ $C $E $thres $baseFile $corruptPercentage" >> ./job_$E\_$C\_$numStateZ
        done
    done
done