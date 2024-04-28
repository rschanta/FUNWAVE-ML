# FUNWAVE Executables

## Preliminaries

### Makefiles

FUNWAVE is a Fortran-based program that must be *compiled* to create an *executable* that is then run. It uses the standard
***Makefile*** to compile all the necessary files into an executable. This only has to be once, provided that the same version
is being used each time.

### Versions

Additionally, FUNWAVE has been updated and developed extensively over the years, with many versions available at the official
[FUNWAVE Wiki Github/Repo](https://fengyanshi.github.io/build/html/setup.html#download-source-code). Different versions may
be needed at different times.

### Modules

FUNWAVE also has different *modules* that use a different set of inputs to compile the executable. More details on all the modules
available can be found at the [FUNWAVE Wiki](https://fengyanshi.github.io/build/html/setup.html#compile-and-setup)

## Suggested Directory Structure and Conventions

The <ins>*work/funwave/*</ins> is used to store FUNWAVE source code and executables. The suggested file structure and conventions
used in this project are:

```
work/
└── funwave/
    ├── v3.6/
    │   └── exec/
    │       ├── FW-REG
    │       └── FW-COUP
    ├── v3.5/
    │   └── exec/
    │       ├── FW-REG
    │       └── FW-COUP
    ├── v3.4/
    │   └── exec/
    │       ├── FW-REG
    │       └── FW-COUP
    └── beta/
        └── exec/
            ├── FW-REG
            └── FW-COUP
```

Here, each executable file begins with *FW-* and then a descriptive tag for the combination of modules used. the convention here is:
* ***FW-REG*** corresponds to *no flags being uncommented*
* ***FW-COUP*** corresponds to **FLAG_1  = -DCOUPLING** being uncommented

It is suggested to move the compiled executables to these folders upon compilation to ensure consistency with this project.
## Common Edits in *Begin Makefile* 

```
#-----------BEGIN MAKEFILE---------------------------
FUNWAVE_DIR = .
WORK_DIR    = exec
COMPILER    = gnu
PARALLEL    = true
EXEC        = FW-COUP
PRECISION   = single
```

The *Begin Makefile* section contains some settings that may need to be changed. It is convenient to change the **EXEC** to 
the name of the executable (eg- **FW-REG**). Additionally, the **compiler** option may need to be changed depending on the 
computer. On the *CAVINESS* system, *it must be changed to **gnu** *. If the `make` command fails, it is likely due to one 
of these settings.