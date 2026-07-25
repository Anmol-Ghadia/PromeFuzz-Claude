# ============== Update these ==============

export AFL_PATH=/root/AFLplusplus/
export LLVM_CONFIG=/usr/bin/llvm-config-19
MAP_DIR="/promefuzz/database/libaom/latest/out/fuzz_driver/maps"
DENYLIST_DIR="/promefuzz/database/libaom/latest/out/fuzz_driver/temp-lists"

# ==========================================

if [ "$1" == "" ]; then
	echo "Missing argument"
	exit
fi

export AFL_LLVM_DENYLIST="$DENYLIST_DIR/denylist_$1.txt"
mkdir -p "$DENYLIST_DIR"
rm "$AFL_LLVM_DENYLIST"

MAP_FILE="$MAP_DIR/map_$1.txt"

mkdir -p "$MAP_DIR"
rm "$MAP_FILE"

rm "$AFL_LLVM_DENYLIST"
DRIVER="/promefuzz/database/libaom/latest/out/fuzz_driver/fuzz_driver_$1.c"

{
  printf '%s\n' '# harness file'
  printf '%s\n' 'src:*fuzz_driver_*.c'
  printf '%s\n' '# harness functions'
  ctags -x --c-kinds=f --language-force=c "$DRIVER" | awk '{print "fun:" $1}'
} > "$AFL_LLVM_DENYLIST"

echo "+++ GENERATED DENYLIST for $DRIVER"
cat -A "$AFL_LLVM_DENYLIST"

#sleep 5

AFL_USE_ASAN=1 \
	AFL_LLVM_DOCUMENT_IDS="$MAP_FILE" \
	afl-clang-lto "$DRIVER" \
	/root/AFLplusplus/libAFLDriver.a \
	-Wl,--whole-archive /promefuzz/database/libaom/latest/bin_asan/lib/libaom.a \
	-Wl,--no-whole-archive -Wl,--export-dynamic \
	-g \
	-I/promefuzz/database/libaom/latest/bin_asan/include/ \
	-I/promefuzz/database/libaom/latest/bin_asan/include/aom \
	-o "fuzz_driver_$1"
	#AFL_DEBUG=1 \

