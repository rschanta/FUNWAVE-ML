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
    paths.inputs = fullfile(super_path,run_name,'inputs');
    paths.outputs_raw = fullfile(super_path,run_name,'outputs-raw');
    paths.outputs_proc = fullfile(super_path,run_name,'outputs-proc');
    paths.bathy = fullfile(super_path,run_name,'bathy');
    paths.coupling = fullfile(super_path,run_name,'coupling');
    paths.super= super_path;
    paths.run_name = fullfile(super_path,run_name);

    % Base for a given output subdirectory
    paths.out_raw_i = fullfile(paths.outputs_raw,'out_');
    % Input summaries
        % structure .mat
            paths.inputs_s = fullfile(paths.run_name,'inputs-s.mat');
        % table .mat
            paths.inputs_t = fullfile(paths.run_name,'inputs-t.txt');
        % parquet .parquet
            paths.inputs_p = fullfile(paths.run_name,'inputs-p.parquet');
end
