%{
mk_FW_dir
    - make all of the directories needed for the FUNWAVE run and store
      them to a structure (same as list_FW_dirs)
%}
function paths = mk_FW_dir(super_path,run_name)
%% Argument
%{
    - super_path: 
    - run_name
%}

%% Create paths and save names to structure
    paths.inputs = fullfile(super_path,run_name,'inputs');
        mkdir(paths.inputs);
    paths.output_raw = fullfile(super_path,run_name,'outputs-raw');
        mkdir(paths.output_raw);
    paths.output_processed = fullfile(super_path,run_name,'outputs-proc');
        mkdir(paths.output_processed);
    paths.bathy = fullfile(super_path,run_name,'bathy');
        mkdir(paths.bathy);
    paths.coupling_path = fullfile(super_path,run_name,'coupling');
        mkdir(paths.coupling_path);
    paths.super= super_path;
    paths.run = fullfile(super_path,run_name);

    % Base for a given output subdirectory
    paths.out_raw_i = fullfile(paths.output_raw,'out_');
    % Structure of input summaries
    paths.input_sum_path = fullfile(paths.run,'inputs.mat');
end
