function print_FW_in(FWS,path)
    % Open the file
    fid = fopen(path, 'w');

    % Loop through all fields in structure
    fields = fieldnames(FWS);
        for j = 1:numel(fields)
            % Get name of field, make sure it's not 'Files'
            param = fields{j};
            if ~strcmp(param,"Files")
                % Get value of parameter and make sure ok for Fortran
                value = FWS.(param);
                value = valid_Double(value);
                % Print parameter line
                line = strcat(param, " = ",string(value),"\n");
                fprintf(fid,line);
            end
        end

    % Close the file
    fclose(fid);

    %%% valid_Double helper function
    function conv = valid_Double(value)
            if isa(value, 'double')
                % Need to ensure number has a decimal place.
                    conv = string(value);
                    if ~contains(conv, '.')
                       conv = strcat(conv, '.0');
                    end
            else
                conv = value;
            end
        end

end