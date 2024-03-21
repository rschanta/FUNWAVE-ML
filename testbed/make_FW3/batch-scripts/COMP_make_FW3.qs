#!/bin/bash -l
#
#
#SBATCH --nodes=1
#SBATCH --tasks-per-node=32
#SBATCH --job-name=COMP_make_FW3
#SBATCH --partition=thsu
#SBATCH --time=7-00:00:00
#SBATCH --output=./make_FW3/slurm_logs/COMP_out.out
#SBATCH --error=./make_FW3/slurm_logs/COMP_err.out
#SBATCH --mail-user='rschanta@udel.edu'
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --export=ALL
#SBATCH --dependency=afterok:27452034
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
vpkg_require matlab

## Compress outputs from all runs to a single structure
args="'/lustre/scratch/rschanta/','make_FW3'"
run_compress_out $args

rm -rf "/lustre/scratch/rschanta/make_FW3/outputs-proc/"
rm -rf "/lustre/scratch/rschanta/make_FW3/outputs-raw/"
