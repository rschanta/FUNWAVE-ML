# Delete a run's slurm logs and batch scripts
if [ "$#" -eq 0 ]; then
    echo "Error: No arguments provided."
    exit 1
fi

Run2Delete=$1

rm -rf /work/thsu/rschanta/RTS/funwave-runs/{Run2Delete}/
