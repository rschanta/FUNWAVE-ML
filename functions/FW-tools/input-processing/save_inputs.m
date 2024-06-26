%{
save_inputs
    - Takes a structure containing structures of FWS structure of the form
        'input_XXXXX' and saves the following:
            - The structure itself as a MATLAB 7.3 structure
            - A .mat table of same information
            - A .parquet file of the same information
%}

function save_inputs(p,input_struct)
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
            % Construct trial name and get structure, remove 'files' field
                tri_name= append_no('tri_',k);
                FWS = input_struct.(tri_name);
                FWS = rmfield(FWS, 'files');

            try
            % Convert to table and append onto
                FWS_ti = struct2table(FWS);
                FWS_tab = [FWS_tab; FWS_ti];
            catch
                disp('Could not concenate into single table')
            end

        end

    %% Save all files
        % Structure .mat
            save(p.Is,'-struct', 'input_struct', '-v7.3');
            disp('Successfully saved input structure!');
            try
        % Table .mat
           writetable(FWS_tab,p.It);
           disp('Successfully saved input table!');
        % Parquet .parquet
            parquetwrite(p.Ip,FWS_tab);
            disp('Successfully saved input parquet!');
            catch
                disp('Could not concenate into single table')
            end

end
