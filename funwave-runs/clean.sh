# Delete a run
Run2Delete=$1
rm -rf ./${Run2Delete}/batch-scripts
rm -rf ./${Run2Delete}/slurm_logs
