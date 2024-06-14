
if [ "$#" -eq 0 ]; then
    echo "Error: No arguments provided."
    exit 1
fi

Run2Delete=$1
## Delete funwave-work folder
FW_Work_Dir=/work/thsu/rschanta/RTS/funwave-runs/${Run2Delete}/
echo "Deleting "${FW_Work_Dir}
rm -rf ${FW_Work_Dir}

## Delete lustre folder
Results_Dir=/lustre/scratch/rschanta/${Run2Delete}/
echo "Deleting "${Results_Dir}
rm -rf ${SP2DeleteFrom}