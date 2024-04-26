# FWML- Mass Runs of FUNWAVE 

This repository contains useful functions and scripts to run many different FUNWAVE nearshore wave simulations in an efficient
and organized manner for use in data-intensive applications such as Machine Learning

## Formatting Conventions Used Throughout this Guide


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

### Work Directory

For file organization, it is best to designate some ***work directory*** to store all 
necessary code files used to run the simulation. The work directory structure suggested in
this repo looks like this:

```
WORK/
├── data
├── functions
├── funwave
├── funwave-runs
└── README.md
```

The contents of each directory are as follows:

* **data**- Any data needed to generate bathymetry, coupling, spectral, or any other sort 
of data needed for a run. (Note- this is not in the repo since this is potentially large
and problem-dependent)
* **functions**- Helper functions used throughout this workflow. 
See the [functions documentation](doc/functions.md) for more detail

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
* **outputs_raw_PATH** - the directory where FUNWAVE will output the results for each trial within a run. 
Within this directory, there will be individual out_XXXXX directories that contain all the output files
from a given trial, such as *eta_XXXXX*, *u_XXXXX*, etc.
* **outputs_proc_PATH** - the directory where post-processed, condensed data from each trial run will be
generated. As of right now, the data from the each out_XXXXX directory gets compressed into a single MATLAB 
structure to produce out_XXXXX.mat files for each trial.
* **bathy_PATH** - the directory where any required bathymetry files will be found. They should have the 
form bathy_XXXXX.txt corresponding to each trial number.
* **coupling_PATH** - the directory where any required coupling files will be found. They should have the 
form coupling_XXXXX.txt

The resulting directory structure, assuming all these files exist, is:

```
super_path/
├── run_PATH/
│   └── bathy/
│       ├── bathy_00001.txt
│       ├── bathy_00002.txt
│       └── bathy_XXXXX.txt
├── coupling/
│   ├── coupling_00001.txt
│   ├── coupling_00002.txt
│   └── coupling_XXXXX.txt
├── input/
│   ├── input_00001.txt
│   ├── input_00002.txt
│   └── input_XXXXX.txt
├── outputs-proc/
│   ├── out_00001.mat
│   ├── out_00002.mat
│   └── out_XXXXX.mat
└── outputs-raw/
    ├── out_00001/
    │   ├── eta_00001
    │   └── eta_XXXXX
    ├── out_00002/
    │   ├── eta_00001
    │   └── eta_XXXXX
    └── out_XXXXX/
        ├── eta_00001
        └── eta_XXXXX
```

---

## Workflow

### Generation of Inputs
This repository is set up to create all necessary input.txt files needed to run a series 
of FUNWAVE simulations. As previously described, these files get generated to the 
super_path/run_path/input/ directory. These files are programmatically generated via a 
MATLAB script ***that shares the same file name as the run name***. For example, we create
a MATLAB file called 'varying_slopes.m' may contain code that defines 1000 different FUNWAVE
runs defined by some range of parameters. Locally, this 