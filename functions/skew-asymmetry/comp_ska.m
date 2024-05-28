%{
comp_ska
    - compresses the skew and asymmetry for each out_XXXXX output and
       stores to 2 structures: skew and asymmetry
%}


function comp_ska(super_path,run_name)
%% Arguments
%{
    - super_path
    - run_name
%}

%% Get paths
    paths = list_FW_dirs(super_path,run_name);
%% Get all files containing 'out' in the name
    varsearch = ['*','out','*'];
    output_files = {dir(fullfile(paths.outputs_proc, varsearch)).name};
    
%% Loop through all files
    skew_struct = struct();
    asy_struct = struct();
    dep_struct = struct();
    for j = 1:length(output_files)
        try
        % Construct full filepath
            file = fullfile(paths.outputs_proc, output_files{j});
        % Get parts and display progress
            [~,name,~] = fileparts(file);
            disp(['Calculing Skew/Asy for: ', file]);
        % Load in out structur, eta, dep skew/asym
            out_str = load(file);
        
        % Store skew and asymmetry to output structure
            skew_struct.(name) = out_str.skew;
            asy_struct.(name) = out_str.asy;
            dep_struct.(name) = out_str.dep;
            disp(['Processed Trial ', num2str(j)])
        catch
            disp(['Problem with Trial ', num2str(j)])
        end

    end
%% Save 2 files
    skew_name = fullfile(paths.run_name,'skew.mat');
    asy_name = fullfile(paths.run_name,'asy.mat');
    dep_name = fullfile(paths.run_name,'dep.mat');
    save(skew_name,'-struct', 'skew_struct', '-v7.3');
    save(asy_name,'-struct', 'asy_struct', '-v7.3');
    save(dep_name,'-struct', 'dep_struct', '-v7.3');
end
