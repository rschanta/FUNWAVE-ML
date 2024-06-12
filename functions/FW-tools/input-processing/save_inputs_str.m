%{
save_inputs
    - Takes a structure containing structures of FWS structure of the form
        'input_XXXXX' and saves the following:
            - The structure itself as a MATLAB 7.3 structure
            - A .mat table of same information
            - A .parquet file of the same information
%}

function save_input_str(p,input_struct)
%% Arguments
%{
    - paths (structure): paths structure as made from list_FW_dirs
    - input_struct (structure): structure containing structures of FWS 
      structure of the form 'input_XXXXX'
%}

    %% Save structure
        % Structure .mat
            save(p.Is,'-struct', 'input_struct', '-v7.3');
            disp('Successfully saved input structure!');
        % Table .mat

end
