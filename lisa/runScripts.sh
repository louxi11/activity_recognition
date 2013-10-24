
for i in `ls jobs/job*`
do
  echo qsub $i
  qsub $i
done
