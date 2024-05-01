# Using Coupling Files

## Coupling supported by FUNWAVE
As described in the [documentation wiki](https://fengyanshi.github.io/build/html/coupling.html), 
FUNWAVE supports one-way coupling to take a time series of surface elevations (eta) and velocities
(u and v) to use as input forcing to a FUNWAVE model run. The *coupling module*  needs to be enabled
by uncommenting the relevant flag in the Makefile:

```
	-Dcoupling
```

## Using coupling in this workflow
Currently, the workflow is only set up for coupling along the *western* edge. This is done
via the function `print_FW_coupling` function. This function takes in a MATLAB structure with
fields `t`, `u`, `v`, and `eta` as its `data` argument, and the file name/path as the `path` 
argument. This structure must be prepared ahead of time.

## Coupling files folder
It is recommended to use the <ins>*super_path/run_path/coupling*</ins> folder within the 
suggested file structure. This is the default used for any coupling cases in this workflow.