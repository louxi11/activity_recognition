files=`ls *.txt | cut -d'.' -f1 | cut -d'_' -f1 | sort | uniq`
currentFolder=`pwd`
echo $currentFolder
for file in $files
do
    echo $file

    fileSingle=`ls -v ${file}_* | grep -E ${file}_[0-9]\{1,2\}.txt`
    fileTemporal=`ls -v ${file}_* | grep -E ${file}_[0-9]\{1,2\}_[0-9]\{1,2\}.txt`
    numSingle=`echo $fileSingle | wc -w`
    numTemporal=`echo $fileTemporal | wc -w`

    if [ $(($numSingle - 1)) -ne $numTemporal ]
    then
        echo WARNING: $numSingle segments, $numTemporal temporal features
    fi

    # header frame counts
    echo $numSingle $(($numSingle-1)) > $1/$file.txt

    # parse single frame filenames
    for f1 in $fileSingle
    do
        echo $currentFolder/$f1 >> $1/$file.txt
    done

    # parse transition filenames
    cnt=0
    for f2 in $fileTemporal
    do
        cnt=$(($cnt+1))
        if [ $cnt -eq $numSingle ]
        then
            break
        fi
        echo $currentFolder/$f2 >> $1/$file.txt
    done
done