%{
array_ska
    - calculates the skew and asymmetry for each out_XXXXX output and
       stores to 2 structures: skew and asymmetry
%}


function calc_ska(super_path,run_name)

%% Get paths
    paths = list_FW_dirs(super_path,run_name)
%% Get all files containing 'out' in the name
    varsearch = ['*','out','*'];
    output_files = {dir(fullfile(paths.outputs_proc, varsearch)).name};
    
%% Loop through all files
    skew_struct = struct();
    asy_struct = struct();
    for j = 1:length(output_files)
        % Construct full filepath
            file = fullfile(paths.outputs_proc, output_files{j});
        % Get parts
            [~,name,~] = fileparts(file);
            
        % Load in out structur, eta, and calculate skew/asym
            out_str = load(file);
            eta_field = out_str.eta;
            ska = array_ska(eta_field,1);
        
        % Store skew and asymmetry to output structure
            skew_struct.(name) = ska.skew;
            asy_struct.(name) = ska.asy;
        
    end
%% Save 2 files
    skew_name = fullfile(paths.run_name,'skew.mat');
    asy_name = fullfile(paths.run_name,'asy.mat');
    save(skew_name,'-struct', 'skew_struct', '-v7.3');
    save(asy_name,'-struct', 'asy_struct', '-v7.3');
end

