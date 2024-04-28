function compress_out(super_path,run_name)
%% Load in helper functions
    addpath(genpath('/work/thsu/rschanta/RTS/functions/'));
%% Get all important paths
    paths = list_FW_dir(super_path,run_name);
%% Loop through  output_processed directory
    files = dir(fullfile(paths.output_processed, '*.mat')); 
    all_ouputs = struct();
    for i = 1:numel(files)
        % Get 
        filepath = fullfile(paths.output_processed, files(i).name);
        [~, file_name, ~] = fileparts(filepath);
        all_ouputs.(file_name) = load(filepath);

    end
    
%% Save Outputs
    outputs_name = fullfile(paths.run,'outputs.mat');
    save(outputs_name,'-struct', 'all_ouputs', '-v7.3')
end
