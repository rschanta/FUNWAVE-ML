%{
list_FW_dirs
    - returns a structure with all the paths associated with a FUNWAVE run
%}
function paths = list_FW_dirs(super_path,run_name)
%% Argument
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
    paths.out_raw_i = fullfile(paths.output_raw,'out_');
    % Structure of input summaries
    paths.input_sum_path = fullfile(paths.run,'inputs.mat');
end
