# Generating FUNWAVE Input Trials

## The FWS Structure in MATLAB
Different FUNWAVE trials are programmatically defined via the **FWS** structure in MATLAB. The FWS structure
is a generic MATLAB structure that contains all the parameters of an valid ***input.txt*** file. For example, here
are the first few lines of a FWS structure made for a **DEPTH_TYPE=SLOPE** FUNWAVE run:

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
* *Integers* - *must* be explicitly set as an integer since MATLAB defaults to double- such as `int64(16)`. 
This is mostly a concern for **PX** and **PY** variables.

In order to avoid having to specify every variable of a *input.txt* file, several templates are available 
for common case. 

### Associated Files
```
FWS = struct();
        FWS.Files= files;
```
Note that the FWS structure also can has a field called **Files**. This is not printed to the <ins>*input.txt*</ins> file,
but instead can be used to store any other information desired about the run, which may include bathymetry
and coupling files.

### Using the FWS Structure to generate an input file
Once the FWS structure has been created, it can be printed via the helper function `print_FW_in()` found at
<ins>*work/functions/FW-tools/FW-print/print_FW_in*</ins>. Normally, this should be specified as *super_path/run_path/input_path/input_XXXXX.txt*

This function takes 2 arguments, with the first being the FWS structure and the second being the path. 
### Templates
In order to avoid having to specify parameters that may not change all that often every time, several
templates are available as a baseline, from which fields can be modified one-by-one as needed. Current
templates include:
* [**FWS_in_SLP**](input_templates/FWS_in_SLP.md): A FUNWAVE run using the `DEP='SLOPE' setting and a regular wavemaker
* **FWS_in_DATA**: A FUNWAVE run using input bathymetry and a regular wavemaker
* **FWS_in_COUPLE**: A FUNWAVE run using a coupling file

[functions documentation](doc/functions.md)