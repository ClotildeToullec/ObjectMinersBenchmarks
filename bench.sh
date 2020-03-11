START=$(date +%s.%N)
for i in {1..10};
do ../../vms/70-x64/Pharo.app/Contents/MacOS/pharo --headless Miners_JOTBenchmarks.image bench.st;
done
END=$(date +%s.%N)
DIFF=$(echo "Benchmark finished, elapsede time: $END - $START" | bc)

