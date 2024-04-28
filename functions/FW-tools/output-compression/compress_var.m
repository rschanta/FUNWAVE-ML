%{
compress_var
    - compresses all the time steps from a 1D simulation to an array for a
      given variable, where each row is a time step and each column is a 
      position in Mglob
%}
function out_array = compress_var(path,var,Mglob,Nglob)
%% Arguments
%{
    - path: path to out_XXXXX directory
    - var:variable to search for (eta, u, etc.)
    - Mglob: Mglob variable of FUNWAVE
    - Nglob: Nglob variable of FUNWAVE
%}

%% Get all files containing 'var' in the name
    varsearch = ['*',var,'*'];
    output_files = {dir(fullfile(path, varsearch)).name};

%% Loop through all files
    out_array = zeros(length(output_files),Mglob);
    for j = 1:length(output_files)
        file = fullfile(path, output_files{j});
        fileID = fopen(file);
                output = fread(fileID,[Mglob,Nglob],'single');
                output = output';
                fclose(fileID);
            %%% Pull out just a middle row (1D)
                out_array(j,:) = output(2,:);
    end
end
