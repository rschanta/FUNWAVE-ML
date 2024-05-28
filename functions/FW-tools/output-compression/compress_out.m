%{
compress_out
    - compresses all the trials from a given FUNWAVE run to a single trial,
    memory permitting
%}

function compress_out(super_path,run_name)
%% Arguments
%{
    - super_path: super_path for run
    - run_name: run_name of run
%}
%% Get all important paths
    paths = list_FW_dirs(super_path,run_name);
%% Loop through  output_processed directory
    files = dir(fullfile(paths.outputs_proc, '*.mat')); 
    all_ouputs = struct();
    for i = 1:numel(files)
        % Get 
        filepath = fullfile(paths.outputs_proc, files(i).name);
        [~, file_name, ~] = fileparts(filepath);
        all_ouputs.(file_name) = load(filepath);

    end
%% Save Outputs
    outputs_name = fullfile(paths.run_name,'outputs.mat');
    save(outputs_name,'-struct', 'all_ouputs', '-v7.3')
end
