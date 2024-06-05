## Directory Creation
The following functions are ***Bash functions*** used to create directories, move files, edit text, and perform similar tasks. They can all be found in the `/bash-utility/` directory.

| **Function name** | **File**| **Dependencies** | **Purpose**  |
|-------------------|---------|------------------|--------------|
| `create_batch_folders()` | [slurm-bash.sh](bash-utility/slurm-bash.sh)   | N/A | Create folders for batch scripts and slurm logs for a given run |
| `get_slurm_dir()` | [slurm-bash.sh](bash-utility/slurm-bash.sh)   | N/A | Get the name of the slurm directory created by `create_batch_folders()` |
| `get_batch_dir()`| [slurm-bash.sh](bash-utility/slurm-bash.sh)   | N/A | Get the name of the batch directory created by `create_batch_folders()`|

## Batch Script Functionality
### Batch Script Creation
| **Function name** | **File**| **Dependencies** | **Purpose**  |
|-------------------|---------|------------------|--------------|
| `create_batch_basic()`| [slurm-bash.sh](bash-utility/slurm-bash.sh)   | N/A | Create a basic batch (`.qs`) script                                      |
| `create_batch_arr()`| [slurm-bash.sh](bash-utility/slurm-bash.sh)   | N/A | Create a batch (`.qs`) script that is a Slurm array job|
| `create_batch_dep()`  | [slurm-bash.sh](bash-utility/slurm-bash.sh)   | N/A | Create a batch (`.qs`) script that is dependent on some other job |
| `create_batch_arr_dep()` | [slurm-bash.sh](bash-utility/slurm-bash.sh)   | N/A | Create a batch (`.qs`) script that is a slurm array job and dependent on some other job |

### Batch Script Editing
| **Function name** | **File**| **Dependencies** | **Purpose**  |
|-------------------|---------|------------------|--------------|
| `set_slurm()` | [slurm-bash.sh](bash-utility/slurm-bash.sh)   | N/A | Set a specific flag of a batch script |
| `remove_slurm()`  | [slurm-bash.sh](bash-utility/slurm-bash.sh)   | N/A | Remove a specific flag in a batch script |
| `set_slurm_names()` | [slurm-bash.sh](bash-utility/slurm-bash.sh)   | N/A   | Set the job name, output file name, error file name, and email all at once|

### Batch Script Running
| **Function name** | **File**| **Dependencies** | **Purpose**  |
|-------------------|---------|------------------|--------------|
| `run_batch()`            | [slurm-bash.sh](bash-utility/slurm-bash.sh)   | N/A | Run a batch script and get the ID of the slurm job   |

## MATLAB Functionality
### Running scripts and functions
The following functions are just wrapped to more easily run MATLAB functions, since this can be a bit tedious otherwise
| **Function name** | **File**| **Dependencies** | **Purpose**  |
|-------------------|---------|------------------|--------------|
| `run_MATLAB_script()`    | [matlab-bash.sh](bash-utility/matlab-bash.sh) | N/A   | Run a given MATLAB script|
| `run_MATLAB_function()`  | [matlab-bash.sh](bash-utility/matlab-bash.sh) | N/A              | Run a given MATLAB function  |

### MATLAB wrapper functions
The following functions are just wrapped to more easily run MATLAB functions, since this can be a bit tedious otherwise.
| **Function name** | **File**| **Dependencies** | **Purpose**  |
|-------------------|---------|------------------|--------------|
| `run_comp_i()`   | [matlab-bash.sh](bash-utility/matlab-bash.sh) | N/A | |
| `run_compress_out()`| [matlab-bash.sh](bash-utility/matlab-bash.sh) |N/A  | |


## Miscellaneous Utility
| **Function name** | **File**| **Dependencies** | **Purpose**  |
|-------------------|---------|------------------|--------------|
| `get_input_dir()`| [misc-bash.sh](bash-utility/misc-bash.sh) | N/A | Get the input file associated with a given trial (ie- input_XXXXX.txt)   |
| `rm_raw_out_i()`| [misc-bash.sh](bash-utility/misc-bash.sh) | N/A | Remove the RESULT_FOLDER associated with a given trial XXXXX |
| `export_vars()`| [misc-bash.sh](bash-utility/misc-bash.sh) | N/A  | Export Environment Variables to shell |