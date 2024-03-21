function paths = list_FW_dir(super_path,run_name)
    paths.inputs = fullfile(super_path,run_name,'inputs');
    paths.output_raw = fullfile(super_path,run_name,'outputs-raw');
    paths.output_processed = fullfile(super_path,run_name,'outputs-proc');
    paths.bathy = fullfile(super_path,run_name,'bathy');
    paths.coupling_path = fullfile(super_path,run_name,'coupling');
    paths.super= super_path;
    paths.run = fullfile(super_path,run_name);

    % Base for a given output subdirectory
    paths.out_raw_i = fullfile(paths.output_raw,'out_');
    % Structure of input summaries
    paths.input_sum_path = fullfile(paths.run,'inputs.mat');
end
