function paths = mk_FW_dir(super_path,run_name)
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
end
