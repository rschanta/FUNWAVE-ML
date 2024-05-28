#!/bin/bash -l
#
#
#SBATCH --nodes=1
#SBATCH --tasks-per-node=32
#SBATCH --job-name=COMP_Run5_28
#SBATCH --partition=standard
#SBATCH --time=7-00:00:00
#SBATCH --output=./Run5_28/slurm_logs/COMP_out.out
#SBATCH --error=./Run5_28/slurm_logs/COMP_err.out
#SBATCH --mail-user=rschanta@udel.edu
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --export=ALL
#SBATCH --dependency=afterany:27679661
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
		## Compress skew and asymmetry
			run_compress_ska /lustre/scratch/rschanta/ Run5_28 /work/thsu/rschanta/RTS/functions
