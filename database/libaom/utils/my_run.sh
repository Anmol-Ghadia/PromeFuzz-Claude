# ./my_run.sh <driver-num> <experiment-num> <cpu-core>

DIR="out/fuzz_driver_$1"
EXP_DIR="$DIR/exp-$2"

rm -rf "$EXP_DIR"
mkdir -p "$DIR"

AFL_NO_AFFINITY=1 \
	timeout 30s \
	taskset -c "$3" \
	afl-fuzz -i ../../../in/ -o "$EXP_DIR" -- "./fuzz_driver_$1"

#ASAN_OPTIONS=abort_on_error=1:symbolize=0:detect_leaks=0 \
