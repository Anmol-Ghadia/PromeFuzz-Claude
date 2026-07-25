if [ $1 == "build" ]; then
	max_jobs=8
	echo "+++ building $(ls ./fuzz_driver_*.c -1 | wc -l) fuzz_drivers(jobs=$max_jobs)"
	for dir in ./fuzz_driver_*.c; do
		DRIVER_NUM=$(echo "$dir" | sed 's/[^0-9]//g')
		while [ $(jobs -r | wc -l) -ge $max_jobs ]; do
			sleep 0.1
		done
		echo "+++ building fuzz_driver_$DRIVER_NUM"
		bash ./my_build.sh "$DRIVER_NUM" &> /dev/null &
	done;
	wait
	echo "+++ finished building $(ls ./fuzz_driver_*.c -1 | wc -l)"
else
	echo "+++ invalid argument: $1"
fi
