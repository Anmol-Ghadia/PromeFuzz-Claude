# ./exp.sh build <- build all drivers (8 in parallel)
# ./exp.sh fuzz <experiment-num> <- run all fuzz drivers once 
if [ "$1" == "build" ]; then
	max_jobs=8
	echo "+++ building $(ls ./fuzz_driver_*.c -1 | wc -l) fuzz_drivers(jobs=$max_jobs)"
	for dir in ./fuzz_driver_*.c; do
		DRIVER_NUM=$(echo "$dir" | sed 's/[^0-9]//g')
		while [ $(jobs -r | wc -l) -ge $max_jobs ]; do
			sleep 1
		done
		echo "+++ building fuzz_driver_$DRIVER_NUM"
		#sleep 1 &
		bash ./my_build.sh "$DRIVER_NUM" &> /dev/null &
	done;
	wait
	echo "+++ finished building $(ls ./fuzz_driver_*.c -1 | wc -l)"
elif [ "$1" == "fuzz" ]; then # does one round of fuzzing
	if [ -z "$2" ]; then # experiment number
		echo "+++ invalid experiment number (./exp.sh fuzz <experiment-number>)"
		exit
	fi
	max_jobs=8
	echo "+++ fuzzing $driver_count fuzz_drivers (max_jobs=$max_jobs, cores=0-7)"
	echo "+++ started [$(date +%Y-%m-%d\ %H:%M)]"
	driver_index=0
	for dir in ./fuzz_driver_*.c; do
		DRIVER_NUM=$(echo "$dir" | sed 's/[^0-9]//g')
		while [ $(jobs -r | wc -l) -ge $max_jobs ]; do
			sleep 1
		done
		cpu_core=$((driver_index % max_jobs)) # Assign to core: cycle through 0-7
		echo "+++ fuzz_driver_$DRIVER_NUM → core $cpu_core"
		bash ./my_run.sh "$DRIVER_NUM" "$2" "$cpu_core" &> /dev/null &
		((driver_index++))
	done
	wait
	echo "+++ finished fuzzing $driver_count drivers [$(date +%Y-%m-%d\ %H:%M)]"
else
	echo "+++ invalid argument: $1"
fi
