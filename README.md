# FWML- Mass Runs of FUNWAVE 

This repository contains useful functions and scripts to run many different FUNWAVE nearshore wave simulations in an efficient
and organized manner for use in data-intensive applications such as Machine Learning


## Basic Organization

The FUNWAVE simulations are divided into **runs** and **trials**. Each *run* corresponds to some 
range of input parameters of FUNWAVE. Each *trial* within a run is one particular combination 
of inputs.

For example:
* A run called *varying_slopes* that consists of trials with beach slopes of 0.05,0.01, and 0.1.
  This is a single *run* with 3 *trials*.
* A run called *test_bathymetries*  that contains the same offshore input wave conditions under 
25 different bathmetry files would have be a single run with 25 *trials*.

To run a single FUNWAVE simulation, we would create a run with just 1 trial. 

## File Structure

### Required Inputs

For each run initiated, a ***run_name*** and ***super_path*** must be specified.
* **run_name** - the name of the run. This should be *unique* and *descriptive*. For example, 
'varying_slopes_1", "field_data_3_25", etc. This will act as a key identifier and be the name 
of several directories and structures, so chosen valid strings for whatever OS/programming
languages used.
* **super_path** - the path where all FUNWAVE inputs/outputs will be saved to. Note that as
the number of trials goes up, the number of files can quickly reach in the millions/gigabytes
of data, so ensure adequate memory. In the University of Delaware Caviness HPC system, specify
a path in the Lustre scratch folder. For example, 'lustre/scratch/user_name/'

### Directories Created

For each run initiated, a series of subdirectories will be made under the *super_path* specified.
* **run_PATH** - a directory with the name specified by "run_name" will be created under the
"super_path". For example, a run named 'var_slopes" would have a corresponding run_PATH
of "lustre/scratch/user_name/var_slopes".

Within ***run_PATH***, the following directories are created. Note that all of these contain many files and
directories for each trial. Each trial is identified by a 5 digit number referred to as 
***tri_no*** that starts from 1. For example, for a run with 3 trials, we would have ***tri_no***'s
of '00001', '00002' and '00003'. References to XXXXX in names from hereon refer to ***tri_no***.
* **input_PATH** - a directory where all the 'input.txt' files for each FUNWAVE run will be 
generated and stored. Each 'input.txt' file is named 'input_XXXXX.txt'.
* **output_raw_PATH**
---

## Workflow