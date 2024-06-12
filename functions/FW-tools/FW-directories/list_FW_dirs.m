%{
list_FW_dirs
    - returns a structure with all the p associated with a FUNWAVE run
    - within the super_path directory
%}
function p = list_FW_dirs(super_path,run_name)
    %% Arguments
    %{
        - super_path: 
        - run_name
    %}
%% Construct paths/structure
%%% SUPER_PATH
p.SP= super_path;
    %%% RUN_NAME
    p.RN = fullfile(p.SP,run_name);
        %%% INPUTS: `input.txt` TEXT FILES 
        p.i = fullfile(p.RN,'inputs');
            p.i_ = fullfile(p.i,'input_'); 
        %%% INPUTS: PROCESSED INPUT FILES
        p.I = fullfile(p.RN,'inputs-proc');
            p.Is = fullfile(p.I,'In_s.mat');
            p.It = fullfile(p.I,'In_t.txt');
            p.Ip = fullfile(p.I,'In_p.parquet');
        %%% OUTPUTS: DIRECTORY FOR RAW TIME SERIES OUTPUT
            p.o = fullfile(p.RN,'outputs-raw');
                p.o_ = fullfile(p.o,'out_');
        %%% OUTPUTS: DIRECTORY FOR PROCESSED/CONDENSED TIME SERIES OUTPUT
            p.O = fullfile(p.RN,'outputs-proc');
                p.O_ = fullfile(p.O,'Out_');
        %%% BATHYMETRY FILES
            p.b = fullfile(p.RN,'bathy');
                p.b_ = fullfile(p.b,'bathy_');
         %%% BATHYMETRY FIGURES
            p.bF = fullfile(p.RN,'bathy_fig');
                p.bF_ = fullfile(p.bF,'bathy_fig_');
        %%% COUPLING FILES
            p.c = fullfile(p.RN,'coupling');
                p.c_ = fullfile(p.c,'coupling_');
        %%% SPECTRA FILES
            p.sp = fullfile(p.RN,'spectra');
                p.sp_ = fullfile(p.sp,'spectra_');
        %%% SPECTRA FIGURES
            p.spF = fullfile(p.RN,'spectra_fig');
                p.spF_ = fullfile(p.spF,'spectra_fig');
        %%% OTHER FUNWAVE OUTPUTS
            p.F = fullfile(p.RN,'other-FW-out');
                p.Fd = fullfile(p.F,'dep.mat');
                p.Ft = fullfile(p.F,'time_dt.txt');
        %%% OTHER STATITISTICS OF INTEREST
            p.S = fullfile(p.RN,'stats');        
    end