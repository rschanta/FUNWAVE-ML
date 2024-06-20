#!/bin/bash -l
#
#
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --job-name=clean_up
#SBATCH --partition=standard
#SBATCH --time=7-00:00:00
#SBATCH --output=myout.out
#SBATCH --error=myerr.out
#SBATCH --mail-user='rschanta@udel.edu'
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --export=ALL

rm -rf /lustre/scratch/rschanta/coupling_19a/outputs-raw/out_00001
rm -rf /lustre/scratch/rschanta/coupling_19a/outputs-raw/out_00002
rm -rf /lustre/scratch/rschanta/C_Dune3/outputs-raw/out_00001
rm -rf /lustre/scratch/rschanta/C_Dune3/outputs-raw/out_00002
rm -rf /lustre/scratch/rschanta/Spectral_Dune3a/outputs-raw/out_00001
rm -rf /lustre/scratch/rschanta/Spectral_Dune3a/outputs-raw/out_00002
rm -rf /lustre/scratch/rschanta/Spectral_Dune3a/outputs-raw/out_00003
rm -rf /lustre/scratch/rschanta/Spectral_Dune3a/outputs-raw/out_00004
rm -rf /lustre/scratch/rschanta/Spectral_Dune3a/outputs-raw/out_00005
rm -rf /lustre/scratch/rschanta/Spectral_Dune3a/outputs-raw/out_00006
rm -rf /lustre/scratch/rschanta/Spectral_Dune3a/outputs-raw/out_00007
rm -rf /lustre/scratch/rschanta/Spectral_Dune3a/outputs-raw/out_00008
rm -rf /lustre/scratch/rschanta/Spectral_Dune3a/outputs-raw/out_00009
rm -rf /lustre/scratch/rschanta/Spectral_Dune3a/outputs-raw/out_00010
rm -rf /lustre/scratch/rschanta/Spectral_Dune3a/outputs-raw/out_00011
rm -rf /lustre/scratch/rschanta/Spectral_Dune3a/outputs-raw/out_00012
rm -rf /lustre/scratch/rschanta/Spectral_Dune3a/outputs-raw/out_000013
rm -rf /lustre/scratch/rschanta/Spectral_Dune3a/outputs-raw/out_000014
rm -rf /lustre/scratch/rschanta/Spectral_Dune3a/outputs-raw/out_000015
rm -rf /lustre/scratch/rschanta/Spectral_Dune3a/outputs-raw/out_000016
rm -rf /lustre/scratch/rschanta/Spec_Dune3c/outputs-raw/
rm -rf /lustre/scratch/rschanta/Spec_Dune3b/outputs-raw/
rm -rf /lustre/scratch/rschanta/Spec_Dune3a/outputs-raw/
rm -rf /lustre/scratch/rschanta/Run_1_617/outputs-raw/
rm -rf /lustre/scratch/rschanta/model_run_6_v2/outputs-raw/