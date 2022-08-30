#!/bin/bash

THIS_DIR="$(pwd)"
K_DIR=$THIS_DIR/../PsCom/

cd $K_DIR

gcc bignum/rand_vmina.c -o bignum/rand_vmina
for i in $(seq 1 30)
do
touch single-Inst-test/vmina/vmina-$i.test
touch single-Inst-test/vmina/vmina-test-$i.out


# output the test case to "test.s"
./bignum/rand_vmina > single-Inst-test/vmina/vmina-$i.test

starttime=`date +'%Y-%m-%d %H:%M:%S'`

# run the test case "test.s" and output to the "test.out"
krun single-Inst-test/vmina/vmina-$i.test --output-file "single-Inst-test/vmina/vmina-test-$i.out"

endtime=`date +'%Y-%m-%d %H:%M:%S'`
start_seconds=$(date --date="$starttime" +%s);
end_seconds=$(date --date="$endtime" +%s);
echo "本次运行时间： "$((end_seconds-start_seconds))"s"
done
