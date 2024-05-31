%{
compress_ska
    - compresses all the trials from a given FUNWAVE run to a single trial,
    memory permitting
%}

function compress_ska(super_path,run_name)
    %% Arguments
    %{
        - super_path: super_path for run
        - run_name: run_name of run
    %}
    %% Get all important paths
        paths = list_FW_dirs(super_path,run_name);
    %% Loop through  output_processed directory
        files = dir(fullfile(paths.outputs_proc, '*.mat')); 
        ska_files = files(contains({files.name}, 'ska'));
        all_ouputs = struct();
        for i = 1:numel(ska_files)
            % Get 
            filepath = fullfile(paths.outputs_proc, ska_files(i).name);
            [~, file_name, ~] = fileparts(filepath);
            disp(filepath)
            all_ouputs.(file_name) = load(filepath);
    
        end
    %% Save Outputs
        outputs_name = fullfile(paths.run_name,'ska.mat');
        disp(outputs_name);
        save(outputs_name,'-struct', 'all_ouputs', '-v7.3')
    end