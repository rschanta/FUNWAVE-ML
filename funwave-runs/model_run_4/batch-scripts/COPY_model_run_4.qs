#!/bin/bash -l
#
#
#SBATCH --nodes=1
#SBATCH --tasks-per-node=32
#SBATCH --job-name=COPY_model_run_4
#SBATCH --partition=standard
#SBATCH --time=7-00:00:00
#SBATCH --output=./model_run_4/slurm_logs/COPY_out.out
#SBATCH --error=./model_run_4/slurm_logs/COPY_err.out
#SBATCH --mail-user=rschanta@udel.edu
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --export=ALL
#SBATCH --dependency=afterany:27624390
#
#UD_QUIET_JOB_SETUP=YES
#UD_USE_SRUN_LAUNCHER=YES
#UD_DISABLE_CPU_AFFINITY=YES
#UD_MPI_RANK_DISTRIB_BY=CORE
#UD_DISABLE_IB_INTERFACES=YES
#UD_SHOW_MPI_DEBUGGING=YES
#
#
	cp "/lustre/scratch/rschanta/model_run_4/inputs.mat" "./model_run_4/inputs.mat"
	cp "/lustre/scratch/rschanta/model_run_4/outputs.mat" "./model_run_4/outputs.mat"
