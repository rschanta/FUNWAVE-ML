%{
print_FW_coupling
    - prints a FUNWAVE coupling file using boundary values for horizontal
      velocities and eta at some times
%}

function print_FW_coupling(data,path)
%% Arguments
%{
    - data: (struct) structure that contains the following 1D arrays:
        -t: time associated with u,v, and eta
        -u: horizontal velocity
        -v: horizontal velocity
        -eta: surface displace
    - path: path to print to, including file name
%}  

%% Open file, get number of time steps
    disp('Started printing coupling file')
    fID = fopen(path,'w');
    num_steps = length(data.t);

%% write the preamble statement for the coupling file
    fprintf(fID, 'coupling data\n');
    fprintf(fID, 'boundary info: num of points, start point\n');
    fprintf(fID, 'EAST\n\t-1\t\t1\n');
    fprintf(fID, 'WEST\n\t5\t\t1\n');
    fprintf(fID, 'SOUTH\n\t-1\t\t1\n');
    fprintf(fID, 'NORTH\n\t-1\t\t1\n');

%% Loop through each time step to print
    for step = 1:num_steps
        fprintf(fID,'\n\t%f', data.t(step));
        printside(fID, 'EAST', []);
        printside(fID, 'WEST', [data.u(step), data.v(step), data.eta(step)]);
        printside(fID, 'SOUTH', []);
        printside(fID, 'NORTH', []);
    end

%% Close the file and display some outputs
    fclose(fID);
    disp('Finished!');
    fprintf('NOTE: This coupling file starts at time = %f sec\n', data.t(1));
    fprintf('      ends at time = %f sec\n', data.t(end));

    %% PRINTSIDE HELPER FUNCTION
        %{
        printside
            - helper function to print lines of texts to a coupling file
        %}
        function printside(fID, DIR, sidevar)
        %% Arguments
        %{
            - fID: (fileID) file ID for the coupling file
            - DIR: (string) direction ('WEST','EAST','SOUTH','NORTH')
            - sidevar: array of form [u v eta] for the time step
        %}  
            fprintf(fID, ['\n' DIR ' SIDE']);
            if ~isempty(sidevar)
                for val = sidevar
                    fprintf(fID, '\n%16.6E', val);
                end
            end
        end

    end


