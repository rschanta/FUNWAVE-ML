#!/bin/bash -l
#
#
#SBATCH --nodes=1
#SBATCH --tasks-per-node=32
#SBATCH --job-name=RUN_trial_5
#SBATCH --partition=thsu
#SBATCH --time=7-00:00:00
#SBATCH --output=./trial_5/slurm_logs/RUN_out_%a.out
#SBATCH --error=./trial_5/slurm_logs/RUN_err_%a.out
#SBATCH --mail-user='rschanta@udel.edu'
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --export=ALL
#SBATCH --array=1-900
#SBATCH --dependency=afterok:27488095
#
#UD_QUIET_JOB_SETUP=YES
#UD_USE_SRUN_LAUNCHER=YES
#UD_DISABLE_CPU_AFFINITY=YES
#UD_MPI_RANK_DISTRIB_BY=CORE
#UD_DISABLE_IB_INTERFACES=YES
#UD_SHOW_MPI_DEBUGGING=YES
#

. /work/thsu/rschanta/RTS/functions/utility/bash-utils.sh
#
. /opt/shared/slurm/templates/libexec/openmpi.sh
vpkg_require openmpi

## FUNWAVE Executable Path
fun_ex="/work/thsu/rschanta/RTS/funwave/v3.6/exec/FW-REG"

## Construct Input File Name 
in_dir="/lustre/scratch/rschanta/trial_5/inputs/"
NUM=$(printf "%05d" $SLURM_ARRAY_TASK_ID)
input_file="${in_dir}input_${NUM}.txt"

## Run FUNWAVE
${UD_MPIRUN} "$fun_ex" "$input_file"

## Compress outputs from run to single structure
args="'/lustre/scratch/rschanta/','trial_5',${NUM}"
run_compress_out_i $args

rm -rf "/lustre/scratch/rschanta/trial_5/outputs-raw/out_$(printf "%05d" $SLURM_ARRAY_TASK_ID)/"

