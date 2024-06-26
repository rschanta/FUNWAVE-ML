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
        
    %%% Load in Time
        disp(['Searching for: ', 'time_dt']);
        ptr = list_FW_tri_dirs(tr_num,p);
    try
        results.time_dt = load(ptr.time_dt_file);
        no_steps = length(results.time_dt);
        disp(['Successfully got: ', 'time_dt']);
        disp([num2str(no_steps), ' time steps in simulation']);
    catch
        disp(['Did not find: ', 'time_dt']);
    end
        
    %%% Get Dep File
        disp(['Searching for: ', 'dep']);
        try
            results.dep = compress_var(p.o_X,'dep',Mglob,Nglob,no_steps);
            disp(['Successfully got: ', 'dep']);
        catch
            disp(['Did not find: ', 'dep']);
        end
    %%% As defined by case in input.txt (be careful with uppercase)
        Vars = {'ETA','MASK','U', 'V','U_undertow','V_undertow','ROLLER'};
    %%% Deal with undertow separately
    if any(ismember(Vars, {'U_undertow'}))
        Vars(ismember(Vars, {'U_undertow'})) = [];
        results.('U_undertow') = compress_var(p.o_X,['U_undertow','_'],Mglob,Nglob,no_steps);
        disp(['Successfully Compressed: ', 'U_undertow']);
    end
    if any(ismember(Vars, {'V_undertow'}))
        Vars(ismember(Vars, {'V_undertow'})) = [];
        results.('V_undertow') = compress_var(p.o_X,['V_undertow','_'],Mglob,Nglob,no_steps);
        disp(['Successfully Compressed: ', 'V_undertow']);
    end
    %%% Loop through all variables to extract
        for j = 1:length(Vars)
            % Get name of variable in capitals and lowercase, undertow is weird
            VAR = Vars{j};
            var = lower(VAR);
            % Use `compress_var` to get variables into structure
            try
                if FW_in.(VAR)
                    results.(var) = compress_var(p.o_X,[var,'_'],Mglob,Nglob,no_steps);
                    disp(['Successfully Compressed: ', var]);
                else
                    disp(['Note: ', Vars{j}, ' not set as output']);
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