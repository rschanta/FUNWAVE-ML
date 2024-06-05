## Work Directory

For file organization, it is best to designate some **work_directory** to store all 
necessary code files used to run the simulation. The work directory structure suggested in
this repo looks like this:

```
WORK/
├── data
├── functions
├── funwave
├── funwave-runs
├── README.md
└── scripts
```

The contents of each directory are as follows:

* `data/` : Any data needed to generate bathymetry, coupling, spectral, or any other  data needed for a run. (Note- this is not in the repo since this is potentially large.) This can also be natural place to set as the **SUPER_PATH** if LUSTRE storage is not available.
* `functions/` : Helper functions used throughout this workflow. See the [functions documentation](../functions/README.md) for more detail
* `funwave/` : Directory containing FUNWAVE source code and executables.
* `funwave-runs/` : Directory containing subdirectories for each FUNWAVE run, where the inputs
are defined and executed. Batch scripts and logs are generated here, and long-term data should be stored here.
* `scripts/` : Bash scripts used to begin the execution of FUNWAVE.

## Directories Created

For each run initiated, a series of subdirectories will be made under the `SUPER_PATH/` specified.
* `RUN_NAME/` - a directory with the name specified by **RUN_NAME** will be created under the
`SUPER_PATH/`. 

Within **RUN_NAME**, the following directories are created. Note that all of these contain many files and
directories for each trial. Each trial is identified by a 5 digit number referred to as 
**tri_no** that starts from 1. For example, for a run with 3 trials, we would have **tri_no**'s
of **00001**, **00002** and **00003**. References to XXXXX in names from hereon refer to **tri_no**.

* `inputs/` - a directory where all the 'input.txt' files for each FUNWAVE run will be generated and stored. Each 'input.txt' file is named `input_XXXXX.txt`.
* `outputs-raw/` - the directory where FUNWAVE will output the results for each trial within a run. 
Within this directory, there will be individual `out_XXXXX/` directories that contain all the output files
from a given trial, such as `eta_XXXXX`, `u_XXXXX`, etc. Note that do preserve storage, the individual folders within this diirectory are set to automativally delete after being processed/condensed, since millions of files can easily accumulate for large runs.
* `outputs-proc/`- the directory where post-processed, condensed data from each trial run will be
generated. 
* `bathy/` - the directory where any required bathymetry files will be found. They should have the 
form `bathy_XXXXX.txt` corresponding to each trial number.
* `coupling/` - the directory where any required coupling files will be found. They should have the 
form `coupling_XXXXX.txt` corresponding to each trial number.

The resulting directory structure, assuming all these files exist, is:

```
SUPER_PATH/
└── RUN_PATH/
    ├── bathy/
    │   ├── bathy_00001.txt
    │   ├── bathy_00002.txt
    │   └── bathy_XXXXX.txt
    ├── coupling/
    │   ├── coupling_00001.txt
    │   ├── coupling_00002.txt
    │   └── coupling_XXXXX.txt
    ├── inputs/
    │   ├── input_00001.txt
    │   ├── input_00002.txt
    │   └── input_XXXXX.txt
    ├── inputs-proc/
    │   ├── In_p.parquet
    │   ├── In_s.mat
    │   └── In_t.mat
    ├── other-FW-out/
    │   ├── time_dt.txt
    │   ├── dep.out
    │   └── breakwater.out
    ├── outputs-proc/
    │   ├── Out_00001.mat
    │   ├── Out_00002.mat
    │   └── Out_XXXXX.mat
    ├── outputs-raw/
    │   ├── out_00001/
    │   │   ├── eta_00001
    │   │   ├── eta_00002
    │   │   └── eta_XXXXX
    │   ├── out_00002/
    │   │   ├── eta_00001
    │   │   ├── eta_00002
    │   │   └── eta_XXXXX
    │   └── out_XXXXX/
    │       ├── eta_00001
    │       ├── eta_00002
    │       └── eta_XXXXX
    └── stats/
        ├── skew_00001.mat
        ├── skew_00002.mat
        └── skew_XXXXX.mat
```

## Path Helper Function

In order to create and keep track of all of these paths convenients without having to rewrite them constantly,
the helper function [`list_FW_dirs`](../functions/matlab-utility/directory-listings/list_FW_dirs.m) that takes 
in the **super_path** and **run_name** variables to output a structure `p` with fields corresponding fields for all of these paths.

```
	function p = list_FW_dirs(super_path,run_name)
```
The fields of `p` are organized generally such that *lowercase letters* correspond to unprocessed inputs/outputs, while *uppercase letters* correspond to processed inputs/outputs. Fields ending with an underscore *\_* correspond to file paths for individual trials up to the underscore (ie- ***run_name/outputs-raw/out_00001/eta\_***). Trial numbers can be easily appended via the `append_no()` helper function. (ie- `append_no(p.o_,2)` to get ***run_name/outputs-raw/out_00001/eta\_00002*** for the previous example.)

### Inputs

| **Field Name** |**Associated Folder/File**| **Description**| 
| -------- | ------- | ------- |
|`p.i` | `inputs/` | path to folder containing input.txt files|
|`p.i_` |`input_XXXXX.txt` | path to individual `input_XXXXX.txt` file up to the underscore|
|`p.I` |`inputs-proc/` | path to folder condensed files for all the inputs associated with a run|
|`p.Is` | `In_s.mat`| path to a MATLAB .mat structure containing input data for all trials|
|`p.It` |`In_t.txt` | path to a .txt table containing input data for all trials|
|`p.Ip` |`In_p.parquet` | path to a .parquet file containing input data for all trials|

### Outputs
| **Field Name** |**Associated Folder/File**| **Description**| 
| -------- | ------- | ------- |
|`p.o` | `outputs-raw/`| path to a folder containing subdirectories of all the raw ouputs from FUNWAVE|
|`p.o_` | `out_XXXXX`| path to a directory containing all the outputs from FUNWAVE for a particular trial up to the underscore|
|`p.O` | `out_XXXXX`| path to a directory containing all the processed/condensed outputs from the FUNWAVE trials (ie- `Out_00001.mat`)|
|`p.O` | `outputs-proc/`| path to a directory containing all the processed/condensed outputs from the FUNWAVE trials |
|`p.O_` | `Out_XXXXX.mat`| path to a directory containing all the processed/condensed outputs from FUNWAVE for a particular trial up to the underscore|

### Bathymetry and Coupling
| **Field Name** |**Associated Folder/File**| **Description**| 
| -------- | ------- | ------- |
|`p.b` | `bathy/`| path to a folder containing all the needed bathymetry files for a run.|
|`p.b_` | `bathy_XXXXX`|path to individual `bathy_XXXXX.txt` file up to the underscore|
|`p.c` | `coupling/`| path to a folder containing all the needed coupling files for a run.|
|`p.c_` | `coupling_XXXXX`|path to individual `coupling_XXXXX.txt` file up to the underscore|

### Other 
| **Field Name** |**Associated Folder/File**| **Description**| 
| -------- | ------- | ------- |
|`p.F` | `other-FW-out/`|path to other FUNWAVE outputs (ie- log files, time records , breakwater, etc.) |
|`p.Fd` | `other-FW-out/ | path to the FUNWAVE depth file for each trial.|
|`p.Ft` | `other-FW-out/`|path to the FUNWAVE time log for each trial.|
|`p.FS` | `stats/`|path to other statistical outputs calculated during the file compression stage. |


## File Organization within the Work Folder
This repository is set up to create all necessary input.txt files needed to run a series 
of FUNWAVE simulations, run them in parallel, and process them down to condensed data formats.

Work defining inputs happens in the ** WORK_DIR** folder. These files are programmatically generated via a MATLAB script *that shares the same file name as the RUN_NAME*. For example, we create a MATLAB file called `varying_slopes.m` that may contain code that defines 1000 different FUNWAVE. runs defined by some range of parameters. Locally, this should be stored
in a *subdirectory that shares the same file name as the run name within the funwave-runs directory*
For the example given of a name of *varying_slopes*, we would have something like:
```
WORK/
├── data
├── functions
├── funwave
├── funwave-runs/
│   └── varying_slopes/
│       └── varying_slopes.m
└── README.md
└── scripts
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
└── scripts
```
