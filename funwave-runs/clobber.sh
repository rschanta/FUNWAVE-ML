# Delete a run
Run2Delete=$1
SP2DeleteFrom="/lustre/scratch/rschanta/"

# rm -rf ./${Run2Delete}/batch-scripts
# rm -rf ./${Run2Delete}/slurm_logs
rm -rf ${SP2DeleteFrom}${Run2Delete}
