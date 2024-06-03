# Functions 

## Bash Utility Functions
The following functions are ***Bash functions*** used to create directories, move files, edit text, and perform similar tasks. They can all be found in the `/bash-utility/` directory.

| **Function name** | **File** | **Calls** | **Dependencies** | **Purpose**  |
| -------- | ------- | -------- | ------- | ------- |
|`create_batch_folders()` | [slurm-bash.sh](bash-utility/slurm-bash.sh) |N/A | N/A | Create folders for batch scripts and slurm logs for a given run |
|`get_slurm_dir()` | [slurm-bash.sh](bash-utility/slurm-bash.sh) |N/A | N/A | Get the name of the slurm directory created by `create_batch_folders()`|
|`get_batch_dir()` | [slurm-bash.sh](bash-utility/slurm-bash.sh) | N/A | N/A | Get the name of the batch directory created by `create_batch_folders()`  |


### Batch Script Creation
| **Function name** | **File** | **Calls** | **Dependencies** | **Purpose**  |
| -------- | ------- | -------- | ------- | ------- |
|`create_batch_basic()` | [slurm-bash.sh](bash-utility/slurm-bash.sh) |N/A | N/A | Create a basic batch (`.qs`) script |
|`create_batch_arr_dep()` | [slurm-bash.sh](bash-utility/slurm-bash.sh) |N/A | N/A | Create a batch (`.qs`) script that is a slurm array job and dependent on some other job|
|`create_batch_dep()` | [slurm-bash.sh](bash-utility/slurm-bash.sh) | N/A | N/A | Create a batch (`.qs`) script that is dependent on some other job  |

### Batch Script Editing
| **Function name** | **File** | **Calls** | **Dependencies** | **Purpose**  |
| -------- | ------- | -------- | ------- | ------- |
|`set_slurm_names()` | [slurm-bash.sh](bash-utility/slurm-bash.sh) |N/A | N/A | Set different flags within a slurm script |

