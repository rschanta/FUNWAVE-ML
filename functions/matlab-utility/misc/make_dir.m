%{
make_dir
    - extension of MATLAB's `mkdir` that checks for existence first
%}

function make_dir(dir_name)
    % Check if folder exists and make it if it doesn't
    if ~exist(dir_name, 'dir')
        % Create the folder if it doesn't exist
        mkdir(dir_name);
        disp(['Folder "', dir_name, '" created.']);
    else
        disp(['Folder "', dir_name, '" already exists.']);
    
end