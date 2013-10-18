files=`ls *.txt | cut -d'.' -f1 | cut -d'_' -f1 | sort | uniq`
currentFolder=`pwd`
echo $currentFolder
for file in $files
do
    echo $file
    num1=`ls ${file}_{?,??}.txt | wc -l`
    num2=`ls ${file}_*_*.txt | wc -l`

    if [ $(($num1 - 1)) -ne $num2 ]
    then
        echo WARNING: $num1 segments, $num2 temporal features
    fi

    # header frame counts
    echo $num1 $(($num1-1)) > $1/$file.txt

    # parse single frame filenames
    fs=`ls ${file}_{?,??}.txt | sort -n -t _ -k 2`
    for f in $fs
    do
        echo $currentFolder/$f >> $1/$file.txt
    done

    # parse transition filenames
    cnt=0
    fs=`ls ${file}_*_*.txt | sort -n -t _ -k 2`
    for f in $fs
    do
        cnt=$(($cnt+1))
        if [ $cnt -eq $num1 ]
        then
            break
        fi
        echo $currentFolder/$f >> $1/$file.txt
    done
done

echo ALL DONE