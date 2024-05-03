%{
save_inputs
    - Takes a structure containing structures of FWS structure of the form
        'input_XXXXX' and saves the following:
            - The structure itself as a MATLAB 7.3 structure
            - A .mat table of same information
            - A .parquet file of the same information
%}

function save_inputs(paths,input_struct)
%% Arguments
%{
    - paths (structure): paths structure as made from list_FW_dirs
    - input_struct (structure): structure containing structures of FWS 
      structure of the form 'input_XXXXX'
%}
   
    %% Convert to table
        % Initialize table
            FWS_tab = table();
        % Loop through structure to add trial data
        for k = 1:length(fieldnames(input_struct))
            % Construct trial name and get structure, remove 'Files' field
                tri_name= ['input_',sprintf('%05d',k)];
                FWS = input_struct.(tri_name);
                FWS = rmfield(FWS,'Files');
            % Convert to table and append onto
                FWS_ti = struct2table(FWS);
                FWS_tab = [FWS_tab; FWS_ti];
        end

    %% Save all files
        % Structure .mat
            save(paths.inputs_s,'-struct', 'input_struct', '-v7.3')
        % Table .mat
           writetable(FWS_tab,paths.inputs_t)
        % Parquet .parquet
            parquetwrite(paths.inputs_p,FWS_tab)

end
