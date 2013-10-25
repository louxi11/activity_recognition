thres=7
corruptPercentage=inf
baseFile=m2_500
isparallel=true

mkdir -p jobs
cd jobs
rm -f job*

E=0.25
C=0.3
        for numStateZ in {1..4}
        do
            echo "#PBS -lnodes=1:ppn=1" > ./job_$E\_$C\_$numStateZ
            echo "#PBS -lwalltime=100:00:00" >> ./job_$E\_$C\_$numStateZ
            echo "module load mcr" >> ./job_$E\_$C\_$numStateZ
            echo "cd ~/workspace/activity_recognition" >> ./job_$E\_$C\_$numStateZ
            echo "./semi_supervised_template $numStateZ $C $E $thres $baseFile $corruptPercentage $isparallel" >> ./job_$E\_$C\_$numStateZ\_$isparallel
        done
