# ./my_run.sh <driver-num> <experiment-num> <cpu-core>

BASE_DIR="/promefuzz/database/tinycbor/latest/out/fuzz_driver-promefuzz"
DIR="$BASE_DIR/out/fuzz_driver_$1"
EXP_DIR="$DIR/exp-$2"

rm -rf "$EXP_DIR"
mkdir -p "$DIR"

AFL_NO_AFFINITY=1 \
	timeout 1h \
	taskset -c "$3" \
	afl-fuzz -i ../../../in/ -o "$EXP_DIR" -- "$BASE_DIR/fuzz_driver_$1"

#ASAN_OPTIONS=abort_on_error=1:symbolize=0:detect_leaks=0 \
