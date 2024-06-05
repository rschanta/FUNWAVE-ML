%{
compress_i
    - compresses all the outputs from a given FUNWAVE run from the series
      of time-stepping files to a single structure with fields for the 
      following variables:
        - ETA
        - MASK
        - U 
        - V
    
        more variables can be added in the 'Vars' cell array structure
    
    - additionally, applies any statistics functions in `f_list` specified
      as a string. For example, {'skew','asymmetry'} would apply the skew()
      and asymmetry() functions to each output.
%}
function compress_i(super_path,run_name,tr_num,f_list)
    disp('COMPRESSION OF TIME SERIES OUTPUTS')
    %%% Get paths, trial number as string, and path of input/output
        p = list_FW_dirs(super_path,run_name);
        p.o_X = append_no(p.o_,tr_num);
        num_str = tri_no(tr_num);
    %%% Load in input structure for output
        FW_in = load(p.Is,num_str);
        FW_in = FW_in.(num_str);
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
                results.(var) = compress_var(p.o_X,[var,'_'],Mglob,Nglob);
                disp(['Successfully Compressed Trial: ',num_str])
            else
                disp(['Note: ', Vars{j}, ' not set as output'])
            end
        % Error handling if variable not found
        catch
           disp(['Warning: ', Vars{j} ' files not found!']);
        end
        end


    %%% Calculate any statistics and save out
    disp('CALCULATION OF BULK STATISTICS')
        %try
            calc_stats(results,f_list,tr_num,super_path,run_name)
            disp(['Successfully Calculated Statistics for Trial: ',num_str])
        %catch
        %    disp('Could not calculate statistics or none specified.')
        %end
    %%% Save structure
        name = [append_no(p.O_,tr_num),'.mat'];
        save(name,'-struct', 'results', '-v7.3')
        disp(['Successfully Saved Structure for Trial: ',sprintf('%05d',tr_num)])
    
end