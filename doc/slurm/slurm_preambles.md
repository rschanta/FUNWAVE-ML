# SLURM Basics


## What is SLURM?
From slurm directly, 

>***"Slurm is an open source, fault-tolerant, and highly scalable cluster management and job scheduling system for large and small Linux clusters"***

The Caviness HPC system uses slurm to efficiently allocate resources in a fair manner. Slurm has an abundance
of settings that can make automating and scheduling tasks much easier, many of which are used in this workflow.

Recall, that the commands in a ***batch script*** with a `.qs` finally extension can be submitted to SLURM via:
```
	sbatch run_FW.qs
```

Upon running this command, a ***job-number*** is created, which is unique to the submission of this
batch script and used as an identifier.

## The SLURM Preamble: Structure of a batch script
Every batch script submitted via `sbatch` must contain a ***preamble*** that contains important information on 
how the job is run. Settings are set via ***flags*** that can be edited as needed. Most flags are quite
self-descriptive. Here is an example of a generic batch script preamble:

```
#!/bin/bash -l
#
#
#SBATCH --nodes=1
#SBATCH --tasks-per-node=32
#SBATCH --job-name=NAME_OF_JOB
#SBATCH --partition=standard
#SBATCH --time=7-00:00:00
#SBATCH --output=mylog.out
#SBATCH --error=myfail.out
#SBATCH --mail-user='email@udel.edu'
#SBATCH --dependency=afterok:222333444
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --export=ALL
#SBATCH --array=1-4
```

The most basic flags are the `mail-user`, `job-name`, `output`, `error` and flags. 
* `mail-user` : SLURM will provide email updates for the actions specified by `mail-type`. It is
extremely useful to have at least BEGIN, END, and FAIL on to keep an eye on progress.
* `job-name` : specifies the name of the job. This should be short but descriptive, and will appear
in the email. Throughout this project, the name of the batch script also typically doubles as the job name
* `output`: specifies the path to the file where the output of any executables will be printed. This 
includes things like MATLAB print statements, and the FUNWAVE log that outputs results as it steps 
through time. FUNWAVE output files can be quite large.
* `error`: specifies the path to the file where any error messages will be printed. This is broadly
useful for debugging and analyzing code failures.

## Node and Partition
Within the slurm preamble, the `partition`, `tasks-per-node` and `nodes` must be explicitly specified as well.

* `partition`- Specifies which partition in the HPC to run on. Anyone can use the ***standard partition*** in Caviness, although individual groups also have their own
partitions to use. (There are also other partitions available). Code in this repo is written assuming the standard 
partition
* `nodes`- specifies the number of nodes to use. For the purposes of this project and Caviness, use `nodes=1`.
* `task-per-nodes`- specifies the number of tasks to run on each node. See note below.

⚠️ The most important setting is ***task-per-node***. ***This must agree with the PX*PY dimension as specified in the input.txt file and FUNWAVE wiki!***
FUNWAVE will be unable to run if this is not correct. FUNWAVE itself uses parallel computing to efficiently calculate results. For example, if we have PX = 16
and PY=2, we would need to set this value to 32. If instead PX=4 and PX=2, we would need to use 8.

## Dependency
The dependency flag ensures that one batch script does not get executed before another in a sequence. It allows for 
modularity and chaining commands together. For example, we would get an error in the compression script it it executed
right away since there's nothing yet to compress. The `afterok` signifies that the script needs to wait until the script
specified by the ***job number*** to the right of the colon is finished. See the section on how dependencies are
set up here for more information.

## Slurm Arrays
The `array` flag is immensely useful to submit jobs in parallel. This can be used to dramatically speed up the collective 
run of FUNWAVE simulations, since it is possible to run 10 at the same time rather than wait one after one. Some care should be taken
to not hoard resources on your cluster though.

The `array` flag is set as a range of numbers. It is important to note that *the same script is submitted once for every number in this range!* 
Within this script, we can access the value of the array number via the variable **SLURM_ARRAY_TASK_ID** just as
we would any other variable in bash. This is the functionality that allows us to submit many input files in parallel.

For example, the following sbatch script would submit inputs 00001 to 00004 in parallel executing at the same time.

Technically, each element of a job array gets a number associated with it as well after the main job-id, which you may
see in the email notifications and progress checks.

```
#!/bin/bash -l
#
#
#SBATCH --nodes=1
#SBATCH --tasks-per-node=32
#SBATCH --job-name=NAME_OF_JOB
#SBATCH --partition=standard
#SBATCH --time=7-00:00:00
#SBATCH --output=mylog.out
#SBATCH --error=myfail.out
#SBATCH --mail-user='email@udel.edu'
#SBATCH --dependency=afterok:222333444
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --export=ALL
#SBATCH --array=1-4

#UD_QUIET_JOB_SETUP=YES
#UD_USE_SRUN_LAUNCHER=YES
#UD_DISABLE_CPU_AFFINITY=YES
#UD_MPI_RANK_DISTRIB_BY=CORE
#UD_DISABLE_IB_INTERFACES=YES
#UD_SHOW_MPI_DEBUGGING=YES
#

. /work/thsu/rschanta/RTS/functions/utility/bash-utils.sh
#
. /opt/shared/slurm/templates/libexec/openmpi.sh
vpkg_require openmpi

# Get the SLURM ARRAY TASK ID as a 5 digit number
NUM=$(printf "%05d" $SLURM_ARRAY_TASK_ID)

# Run the input file associated with this number.
${UD_MPIRUN} "funwave/v3.6/exec/FW-REG" "input_${NUM}.txt"
```

## UD and Project Specifiec Workflows
To access key functionality such as *OpenMPI* and *MATLAB*, add the following additional flags after
the general slurm preamble:

```
#UD_QUIET_JOB_SETUP=YES
#UD_USE_SRUN_LAUNCHER=YES
#UD_DISABLE_CPU_AFFINITY=YES
#UD_MPI_RANK_DISTRIB_BY=CORE
#UD_DISABLE_IB_INTERFACES=YES
#UD_SHOW_MPI_DEBUGGING=YES
#

. /work/thsu/rschanta/RTS/functions/utility/bash-utils.sh
#
. /opt/shared/slurm/templates/libexec/openmpi.sh
vpkg_require openmpi
vpkg_require matlab
```

Any script executing FUNWAVE will need openmpi, and any script executing a MATLAB script will require MATLAB.

The `bash-utils` line allows us to access the helper functions created in the repo, and the other UD flags can be added as well.

## Template Slurm Preambles
Several template files with various slurm preambles can be generated via the helper functions found in `**/functions/utility/sbatch-slurm-utils.sh**