files=`ls *.txt | cut -d'.' -f1 | cut -d'_' -f1 | sort | uniq`
currentFolder=`pwd`
echo $currentFolder
for file in $files
do
    echo $file
    num3=`ls ${file}_*.txt | wc -l`
    num2=`ls ${file}_*_*.txt | wc -l`
    num1=$(($num3 - $num2))

    # header frame counts
    echo $num1 $num2 > $1/$file.txt

    # parse single frame filenames
    if [ $num1 -gt 9 ]
    then
        fs=`ls ${file}_{?,??}.txt | sort -n -t _ -k 2`
    else
        fs=`ls ${file}_?.txt | sort -n -t _ -k 2`
    fi
    for f in $fs
    do
        echo $currentFolder/$f >> $1/$file.txt
    done

    # parse transition filenames
    fs=`ls ${file}_*_*.txt | sort -n -t _ -k 2`
    for f in $fs
    do
        echo $currentFolder/$f >> $1/$file.txt
    done
done
