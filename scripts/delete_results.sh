# Delete a run from lustre
if [ "$#" -eq 0 ]; then
    echo "Error: No arguments provided."
    exit 1
fi
Run2Delete=$1
SP2DeleteFrom=/lustre/scratch/rschanta/{Run2Delete}/
rm -rf ${SP2DeleteFrom}
