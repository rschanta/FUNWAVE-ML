#!/bin/bash -l
#
#
#SBATCH --nodes=1
#SBATCH --tasks-per-node=32
#SBATCH --job-name=DEP_trial_5
#SBATCH --partition=thsu
#SBATCH --time=7-00:00:00
#SBATCH --output=./slurm_logs/DEP_out_%a.out
#SBATCH --error=./slurm_logs/SKA_err_%a.out
#SBATCH --mail-user='rschanta@udel.edu'
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --export=ALL
#SBATCH --array=1-900
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
no=$SLURM_ARRAY_TASK_ID

run_MATLAB_function "./" "get_dep_f" "$no"