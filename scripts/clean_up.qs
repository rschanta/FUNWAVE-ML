#!/bin/bash -l
#
#
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --job-name=clean_up
#SBATCH --partition=thsu
#SBATCH --time=7-00:00:00
#SBATCH --output=myout.out
#SBATCH --error=myerr.out
#SBATCH --mail-user='rschanta@udel.edu'
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --export=ALL

du -h --max-depth=1 /lustre/scratch/rschanta | sort -rh | head -n 10