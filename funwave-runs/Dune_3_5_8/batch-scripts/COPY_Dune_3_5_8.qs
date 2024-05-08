#!/bin/bash -l
#
#
#SBATCH --nodes=1
#SBATCH --tasks-per-node=32
#SBATCH --job-name=COPY_Dune_3_5_8
#SBATCH --partition=standard
#SBATCH --time=7-00:00:00
#SBATCH --output=./Dune_3_5_8/slurm_logs/COPY_out.out
#SBATCH --error=./Dune_3_5_8/slurm_logs/COPY_err.out
#SBATCH --mail-user=rschanta@udel.edu
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --export=ALL
#SBATCH --dependency=afterany:27620450
#
#UD_QUIET_JOB_SETUP=YES
#UD_USE_SRUN_LAUNCHER=YES
#UD_DISABLE_CPU_AFFINITY=YES
#UD_MPI_RANK_DISTRIB_BY=CORE
#UD_DISABLE_IB_INTERFACES=YES
#UD_SHOW_MPI_DEBUGGING=YES
#
#
	cp "/lustre/scratch/rschanta/Dune_3_5_8/inputs.mat" "./Dune_3_5_8/inputs.mat"
	cp "/lustre/scratch/rschanta/Dune_3_5_8/outputs.mat" "./Dune_3_5_8/outputs.mat"
