## Work Directory

For file organization, it is best to designate some <span style="color:Blue">**work_directory**</span> to store all 
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

* <span style="color:Blue">**data**</span>- Any data needed to generate bathymetry, coupling, spectral, or any other sort 
of data needed for a run. (Note- this is not in the repo since this is potentially large
and problem-dependent)
* <span style="color:Blue">**functions**</span>- Helper functions used throughout this workflow. 
See the [functions documentation](./doc/functions.md) for more detail

## Directories Created

For each run initiated, a series of subdirectories will be made under the *super_path* specified.
* <span style="color:Blue">**run_name**</span> - a directory with the name specified by <span style="color:Red">**run_name**</span> will be created under the
"super_path". For example, a run named <span style="color:Red">*run_name*</span> would have a corresponding path
of <span style="color:Blue">*lustre/scratch/user_name/var_slopes*</span>.

Within <span style="color:Blue">**run_name**</span>, the following directories are created. Note that all of these contain many files and
directories for each trial. Each trial is identified by a 5 digit number referred to as 
<span style="color:Red">**tri_no**</span> that starts from 1. For example, for a run with 3 trials, we would have <span style="color:Red">**tri_no**</span>'s
of <span style="color:Red">*00001*</span>, <span style="color:Red">*00002*</span> and <span style="color:Red">*00003*</span>. References to XXXXX in names from hereon refer to <span style="color:Red">**tri_no**</span>.

* <span style="color:Blue">**inputs**</span> - a directory where all the 'input.txt' files for each FUNWAVE run will be 
generated and stored. Each 'input.txt' file is named <span style="color:Green">**input_XXXXX.txt**</span>.
* <span style="color:Blue">**outputs_raw**</span> - the directory where FUNWAVE will output the results for each trial within a run. 
Within this directory, there will be individual <span style="color:Blue">**out_XXXXX**</span> directories that contain all the output files
from a given trial, such as <span style="color:Green">**eta_XXXXX**</span>, <span style="color:Green">**u_XXXXX**</span>, etc.
* <span style="color:Blue">**outputs_proc**</span> - the directory where post-processed, condensed data from each trial run will be
generated. As of right now, the data from the each out_XXXXX directory gets compressed into a single MATLAB 
structure to produce <span style="color:Green">**out_XXXXX.mat**</span> files for each trial.
* <span style="color:Blue">**bathy**</span> - the directory where any required bathymetry files will be found. They should have the 
form <span style="color:Green">**bathy_XXXXX.txt**</span> corresponding to each trial number.
* <span style="color:Blue">**coupling**</span> - the directory where any required coupling files will be found. They should have the 
form <span style="color:Green">**coupling_XXXXX.txt**</span>

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

## Path Helper Function

In order to create and keep track of all of these paths convenients without having to rewrite them constantly,
the helper function <span style="color:Purple">**list_FW_dirs**</span> that takes in the <span style="color:Red">**super_path**</span>
and <span style="color:Red">**run_name**</span> variables to output a structure <span style="color:Red">**paths**</span> with fields
corresponding fields for all of these paths (note- dashes are replaced by underscores)

```
	function paths = list_FW_dirs(super_path,run_name)
```


## File Organization within the Work Folder
This repository is set up to create all necessary input.txt files needed to run a series 
of FUNWAVE simulations. As previously described, these files get generated to the 
<span style="color:Blue">*super_path/run_path/input/*</span> directory. 

Work defining these inputs happens in the WORK folder. These files are programmatically generated via a 
MATLAB script ***that shares the same file name as the run name***. For example, we create
a MATLAB file called <span style="color:Green">*varying_slopes.m*</span> that may contain code that defines 1000 different FUNWAVE
runs defined by some range of parameters. Locally, this should be stored
in a ***subdirectory that shares the same file name as the run name within the funwave-runs directory*** 
For the example given of a name of <span style="color:Red">*varying_slopes*</span>, we would have something like:
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
