SCRIPTNAME="bench"
SCRIPTVERSION=$1
SCRIPTEXT=".st"
SCRIPT=$SCRIPTNAME$SCRIPTVERSION$SCRIPTEXT
START=$(date +%s)
#for i in {1..1};
#do ../../vms/70-x64/Pharo.app/Contents/MacOS/pharo --headless Miners_RFTest $SCRIPT;
#done
../../vms/70-x64/Pharo.app/Contents/MacOS/pharo --headless Miners_RFTest $SCRIPT;
END=$(date +%s)
let "DIFF=$END - $START"
echo -e "\nBenchmarks ended in $DIFF seconds"
