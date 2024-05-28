#!/bin/bash -l
#
#
#SBATCH --nodes=1
#SBATCH --tasks-per-node=32
#SBATCH --job-name=GEN_Run5_28
#SBATCH --partition=standard
#SBATCH --time=7-00:00:00
#SBATCH --output=./Run5_28/slurm_logs/GEN_out.out
#SBATCH --error=./Run5_28/slurm_logs/GEN_err.out
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
		run_MATLAB_script "./Run5_28/Run5_28.m" "/work/thsu/rschanta/RTS/functions"
