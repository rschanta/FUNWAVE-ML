%{
print_FW_in
    - takes in a FWS structure to print a valid `input.txt` file for 
      FUNWAVE to the path specified
%}
function print_FW_in(FWS,path)
%% Arguments
%{
    - FWS: FWS structure to print out
    - path: path to print too, including file name
%}
%% Open the file
    fid = fopen(path, 'w');

%% Loop through all fields in structure
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

%% Close the file
    fclose(fid);
    %% Helper Function
    %{
    valid_Double
        - convert a MATLAB double to a valid FORTRAN double by ensuring
          that it has a decimal place. (Effectively just adds a .0 to
          a MATLAB double that happens to be an integer
    %}
    function conv = valid_Double(value)
        %% Arguments
        %{
            - value: numeric value to convert into a FORTRAN double
        %}
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