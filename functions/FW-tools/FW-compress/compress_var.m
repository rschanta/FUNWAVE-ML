function out_array = compress_var_1D(path,var,Mglob,Nglob)

    %%% Get all files containing 'var' in the name
        varsearch = ['*',var,'*'];
        output_files = {dir(fullfile(path, varsearch)).name};

    %%% Loop through all files
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
