baseFile=\'m2_500\'
corruptPercentage=inf
thres=7
for E in 0.2 0.4 0.6 0.8 1.0 1.3 1.6 2.0 2.5 3.0
do
    for C in 0.2 0.4 0.6 0.8 1.0 1.3 1.6 2.0 2.5 3.0
    do
        cmd=\"evaluation_template\($C,$E,$thres,$baseFile,$corruptPercentage\)\"
        echo $cmd
        #echo nohup matlab -nojvm -nodisplay -nosplash -r $cmd \> $E$C.log
        echo matlab -nojvm -nodisplay -nosplash -r $cmd
        matlab -nojvm -nodisplay -nosplash -r "evaluation_template($C,$E,$thres,$baseFile,$corruptPercentage)"

    done
done
