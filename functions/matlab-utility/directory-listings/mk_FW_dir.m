%{
mk_FW_dir
    - make all of the directories needed for the FUNWAVE run and store
      them to a structure (same as list_FW_dirs)
%}
function paths = mk_FW_dir(super_path,run_name)
%% Arguments
%{
    - super_path: 
    - run_name:
%}

%% Create paths and save names to structure
    paths.inputs = fullfile(super_path,run_name,'inputs');
        mkdir(paths.inputs);
    paths.outputs_raw = fullfile(super_path,run_name,'outputs-raw');
        mkdir(paths.outputs_raw);
    paths.outputs_proc = fullfile(super_path,run_name,'outputs-proc');
        mkdir(paths.outputs_proc);
    paths.bathy = fullfile(super_path,run_name,'bathy');
        mkdir(paths.bathy);
    paths.coupling = fullfile(super_path,run_name,'coupling');
        mkdir(paths.coupling);
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
