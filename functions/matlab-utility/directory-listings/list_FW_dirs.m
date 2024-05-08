%{
list_FW_dirs
    - returns a structure with all the paths associated with a FUNWAVE run
%}
function paths = list_FW_dirs(super_path,run_name)
%% Arguments
%{
    - super_path: 
    - run_name
%}
%% Construct paths/structure
    %%% OUTER DIRECTORIES
        paths.super= super_path;
        paths.run_name = fullfile(super_path,run_name);
    %%% INPUTS
        paths.inputs = fullfile(super_path,run_name,'inputs');
        paths.inputs_s = fullfile(paths.run_name,'inputs-s.mat');
        paths.inputs_t = fullfile(paths.run_name,'inputs-t.txt');
        paths.inputs_p = fullfile(paths.run_name,'inputs-p.parquet');
    %%% OUTPUTS
        paths.outputs_raw = fullfile(super_path,run_name,'outputs-raw');
        paths.outputs_proc = fullfile(super_path,run_name,'outputs-proc');
        paths.out_raw_i = fullfile(paths.outputs_raw,'out_');
    %%% OTHER FILES
        paths.bathy = fullfile(super_path,run_name,'bathy');
        paths.coupling = fullfile(super_path,run_name,'coupling');
    %%% OTHER PROCESSED OUTPUTS
        paths.dep = fullfile(super_path,run_name,'dep.mat');
        paths.skew = fullfile(super_path,run_name,'skew.mat');
        paths.asy = fullfile(super_path,run_name,'asy.mat');
    
    
end
