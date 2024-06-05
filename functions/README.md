# Functions 
Helper functions used are extensively documented and organized by language and purpose into subdirectories. Documentation for each can be found at:

## bash-utility
The [bash-utility](./bash-utility/README.md) functions enable bash functionality to help with running functions via the terminal and schedule jobs via SLURM.
| **Bash Script** | **Description**|
| -------- | ------- | 
|`get-bash.sh` |script run to initialize a bash environment with all helper functions found in `matlab-bash.sh` `misc-bash.sh` and `slurm-bash.sh` | 
|`matlab-bash.sh` |contains functions to easily run MATLAB functions and scripts via the command line, including wrapper functions | 
|`misc-bash.sh` | contains miscellaneous bash utility functions | 
|`slurm-bash.sh` | contains functions to create `.qs` batch scripts, edit their flags, create folders for them, and get these folders name | 

## FW-tools
The [FW-tools](./FW-tools/README.md) functions provide functions for the creation of FUNWAVE inputs and compression of FUNWAVE outputs in MATLAB and in text files where relevant.
| **Subdirectory** | **Description**|
| -------- | ------- | 
|`/input-templates` |contains functions to create common `input.txt` MATLAB structures for different FUNWAVE  | 
|`/output-compression` |contains functions to compress all of the output files from a FUNWAVE trial (ie- eta_XXXXX, u_XXXXX) to a single MATLAB structure and calculate statistics on them | 
|`/print-files` |contains functions to print FUNWAVE `input.txt`, `bathy.txt`, and `coupling.txt` files | 

## matlab-utility
The [matlab-utility](./matlab-utility/README.md) functions provide useful tools for utilizing this FUNWAVE workflow while in MATLAB.
| **Subdirectory** | **Description**|
| -------- | ------- | 
|`/animation` |functions to animate time series outputs of FUNWAVE | 
|`/directory-listings` |functions to create directories for FUNWAVE inputs/outputs and get these directories as strings | 
|`/hydrodynamics` |functions to calculate hydrodynamics variables of interest (ie- dispersion relation, wave statistics)| 
|`/misc` | miscellaneous functionality | 

## skew-asymmetry
The [statistics](./matlab-utility/README.md) functions provide the functionality to calculate bulk statistics on compressed time series
| **Subdirectory** | **Description**|
| -------- | ------- | 
|`/animation` |functions to animate time series outputs of FUNWAVE | 
|`/directory-listings` |functions to create directories for FUNWAVE inputs/outputs and get these directories as strings | 
|`/hydrodynamics` |functions to calculate hydrodynamics variables of interest (ie- dispersion relation, wave statistics)| 
|`/misc` | miscellaneous functionality |