files=`ls *.txt | cut -d'_' -f1 | sort | uniq`
for file in $files
do
    echo $file
    f1=`ls ${file}_?.txt | wc -l`
    f2=`ls ${file}_??.txt | wc -l`
    echo $(($f1 + $f2)) $(($f1 + $f2 - 1)) > $file.txt
    ls ${file}_?.txt >> $file.txt
    ls ${file}_??.txt >> $file.txt
    ls ${file}_*_*.txt | sort -n -t _ -k 2 >> $file.txt
    break
done