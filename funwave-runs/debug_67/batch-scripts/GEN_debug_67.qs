#!/bin/bash -l
#
#
#SBATCH --nodes=1
#SBATCH --tasks-per-node=32
#SBATCH --job-name=GEN_debug_67
#SBATCH --partition=standard
#SBATCH --time=7-00:00:00
#SBATCH --output=./debug_67/slurm_logs/GEN_out.out
#SBATCH --error=./debug_67/slurm_logs/GEN_err.out
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
	## Load in bash functions and VALET packages
		. "/work/thsu/rschanta/RTS/functions/bash-utility/get_bash.sh"
		vpkg_require matlab
	## Run Generation Script
		run_MATLAB_script "./debug_67/debug_67.m" "/work/thsu/rschanta/RTS/functions"
