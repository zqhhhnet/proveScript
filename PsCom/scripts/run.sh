#!/bin/bash

THIS_DIR="$(pwd)"
K_DIR=$THIS_DIR/../PsCom/

cd $K_DIR

touch single-Inst-test/vmaxnmav.test
touch single-Inst-test/vmaxnmav-test.out
gcc rand_vmaxnmav.c -o rand_vmaxnmav

# output to the test case
./rand_vmaxnmav > single-Inst-test/vmaxnmav.test

starttime=`date +'%Y-%m-%d %H:%M:%S'`

# run the test case and output
krun single-Inst-test/vmaxnmav.test --output-file "single-Inst-test/vmaxnmav-test.out"

endtime=`date +'%Y-%m-%d %H:%M:%S'`
start_seconds=$(date --date="$starttime" +%s);
end_seconds=$(date --date="$endtime" +%s);
echo "本次运行时间： "$((end_seconds-start_seconds))"s"

