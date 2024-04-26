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

### File Organization within the Work Folder
This repository is set up to create all necessary input.txt files needed to run a series 
of FUNWAVE simulations. As previously described, these files get generated to the 
super_path/run_path/input/ directory. 

Work defining these inputs happens in the WORK folder. These files are programmatically generated via a 
MATLAB script ***that shares the same file name as the run name***. For example, we create
a MATLAB file called 'varying_slopes.m' that may contain code that defines 1000 different FUNWAVE
runs defined by some range of parameters. Locally, this should be stored
in a ***subdirectory that shares the same file name as the run name within the funwave-runs directory*** 
For the example given of a name of 'varying_slopes', we would have something like:
```
WORK/
├── data
├── functions
├── funwave
├── funwave-runs/
│   └── varying_slopes/
│       └── varying_slopes.m
└── README.md
```

Generically, this is:
```
WORK/
├── data
├── functions
├── funwave
├── funwave-runs/
│   └── run_name/
│       └── run_name.m
└── README.md
```

### The FWS Structure in MATLAB
Different FUNWAVE trials are programmatically defined via the **FWS** structure in MATLAB. The FWS structure
is a generic MATLAB structure that contains all the parameters of an valid `input.txt` file. For example, here
are the first few lines of a FWS structure made for a 'DEPTH_TYPE=SLOPE' FUNWAVE run:

```
FWS = struct();
    %%% Title Info
        FWS.TITLE = 'input_SLP.txt';
    %%% Parallel Info
        FWS.PX = int64(16); 
        FWS.PY = int64(2);
    %%% Depth Info
        FWS.DEPTH_TYPE = 'SLOPE';
        FWS.DEPTH_FLAT = 5; 
        FWS.SLP = 0.1;
        FWS.Xslp = 800; 
	%%% Associated Files
        files = struct();
        FWS.Files= files;
```

The field names of the FWS structure must exactly match the desired corresponding parameter in the *input.txt*
file. Note that FUNWAVE is written in FORTRAN, so some care should be taken with data types:

* *Booleans and Strings* - input as a MATLAB string, such as `'SLP'` or `'T'`
* *Doubles* - input as a standard MATLAB double, such as `5`
* *Integers* - **must** be explicitly set as an integer since MATLAB defaults to double- such as `int64(16)`. 
This is mostly a concern for *PX* and *PY* variables.

In order to avoid having to specify every variable of a *input.txt* file, several templates are available 
for common case. 

#### Associated Files
```
FWS = struct();
        FWS.Files= files;
```
Note that the FWS structure also can has a field called "Files". This is not printed to the *input.txt* folder,
but instead can be used to store any other information desired about the run, which may include bathymetry
and coupling files.

#### Templates
In order to avoid having to specify parameters that may not change all that often every time, several
templates are available as a baseline, from which fields can be modified one-by-one as needed. Current
templates include:
* [**FWS_in_SLP**](doc/input/templates/FWS_in_SLP.md): A FUNWAVE run using the `DEP='SLOPE' setting and a regular wavemaker
* **FWS_in_DATA**: A FUNWAVE run using input bathymetry and a regular wavemaker
* **FWS_in_COUPLE**: A FUNWAVE run using a coupling file

[functions documentation](doc/functions.md)