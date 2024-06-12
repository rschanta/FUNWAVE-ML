%{
mk_dirs
    - make all of the directories defined in
    - `list_dirs`needed for the FUNWAVE run and store
      them to a structure
%}
function p = mk_FW_dir(super_path,run_name)
    %% Arguments
    %{
        - super_path: 
        - run_name:
    %}

    %%% Get list of directories from list_FW_dirs
    p = list_FW_dirs(super_path,run_name);

    %%% RUN_NAME
    make_dir(p.RN);
        %%% INPUTS: `input.txt` TEXT FILES 
        make_dir(p.i) ;
        %%% INPUTS: PROCESSED INPUT FILES
        make_dir(p.I);
        %%% OUTPUTS: DIRECTORY FOR RAW TIME SERIES OUTPUT
            make_dir(p.o);
        %%% OUTPUTS: DIRECTORY FOR PROCESSED/CONDENSED TIME SERIES OUTPUT
            make_dir(p.O); 
        %%% BATHYMETRY FILES
            make_dir(p.b); 
        %%% COUPLING FILES
            make_dir(p.c); 
        %%% SPECTRA FILES
            make_dir(p.sp); 
        %%% OTHER FUNWAVE OUTPUTS
            make_dir(p.F); 
        %%% OTHER STATITISTICS OF INTEREST
            make_dir(p.S); 
    disp('Directories successfully created!')
        
    end