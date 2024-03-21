#!/bin/bash -l
#
#
#SBATCH --nodes=1
#SBATCH --tasks-per-node=32
#SBATCH --job-name=COPY_make_FW3
#SBATCH --partition=thsu
#SBATCH --time=7-00:00:00
#SBATCH --output=./make_FW3/slurm_logs/COPY_out.out
#SBATCH --error=./make_FW3/slurm_logs/COPY_err.out
#SBATCH --mail-user='rschanta@udel.edu'
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --export=ALL
#SBATCH --dependency=afterok:27452035
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
cp "/lustre/scratch/rschanta/make_FW3/inputs.mat" "./make_FW3/inputs.mat"
cp "/lustre/scratch/rschanta/make_FW3/outputs.mat" "./make_FW3/outputs.mat"
