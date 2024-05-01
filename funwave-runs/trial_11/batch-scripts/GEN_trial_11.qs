#!/bin/bash -l
#
#
#SBATCH --nodes=1
#SBATCH --tasks-per-node=32
#SBATCH --job-name=GEN_trial_11
#SBATCH --partition=thsu
#SBATCH --time=7-00:00:00
#SBATCH --output=./trial_11/slurm_logs/GEN_out.out
#SBATCH --error=./trial_11/slurm_logs/GEN_err.out
#SBATCH --mail-user=rschanta@udel.edu
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --export=ALL
#
#UD_QUIET_JOB_SETUP=YES
#UD_USE_SRUN_LAUNCHER=YES
#UD_DISABLE_CPU_AFFINITY=YES
#UD_MPI_RANK_DISTRIB_BY=CORE
#UD_DISABLE_IB_INTERFACES=YES
#UD_SHOW_MPI_DEBUGGING=YES
#
#
## Load in utilities and VALET
. "/work/thsu/rschanta/RTS/functions/bash-utility/slurm-bash.sh"
. "/work/thsu/rschanta/RTS/functions/bash-utility/matlab-bash.sh"
. "/work/thsu/rschanta/RTS/functions/bash-utility/misc-bash.sh"
	vpkg_require matlab

## Run Generation Script
	run_MATLAB_script2 "./trial_11/trial_11.m" "/work/thsu/rschanta/RTS/functions"
