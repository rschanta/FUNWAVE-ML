%{
compress_out_i
    - compresses all the outputs from a given FUNWAVE run from the series
      of time-stepping files to a single structure with fields for the 
      following variables:
        - ETA
        - MASK
        - U 
        - V
    
        more variables can be added in the 'Vars' cell array structure
%}
function comp_i(super_path,run_name,tri_no)
    %%% Get paths, trial number as string, and path of input/output
        paths = list_FW_dirs(super_path,run_name);
        tri_no_str = ['input_',sprintf('%05d',tri_no)];
        res_path = [paths.out_raw_i,sprintf('%05d',tri_no)];
    %%% Load in input structure for output
        FW_in = load(paths.inputs_s,tri_no_str);
        FW_in = FW_in.(tri_no_str);
    %%% Get Mglob and Nglob
        Mglob = double(FW_in.Mglob);
        Nglob = double(FW_in.Nglob);
    %%% Initialize variables and desired outputs
        results = struct();
        Vars = {'ETA','MASK','U', 'V'};
    %%% Loop through all variables to extract
        for j = 1:length(Vars)
        % Get name of variable in capitals and lowercase
            VAR = Vars{j};
            var = lower(VAR);
        % Use `compress_var` to get variables into structure
        try
            if FW_in.(VAR)
                results.(var) = compress_var(res_path,[var,'_'],Mglob,Nglob);
            else
                disp(['Note: ', Vars{j}, ' not set as output'])
            end
        % Error handling if variable not found
        catch
         %   disp(['Warning: ', Vars{j} ' files not found!']);
        end
        end
    %%% Save structure
        name = fullfile(paths.outputs_proc,['out_',sprintf('%05d',tri_no),'.mat']);
        save(name,'-struct', 'results', '-v7.3')
    
end