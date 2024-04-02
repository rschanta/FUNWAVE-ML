function print_FW_coupling(data,path)
%%% ARGUMENTS
    % data (structure): structure with 1D equal length vectors for:
        % t
        % u
        % v
        % eta
% Display start
    disp('Starting printing coupling file')
% Get the number of time steps
    num_steps = length(data.t);

    % Open coupling file
    fID = fopen(path,'w');

    % Write the static information
    fprintf(fID, 'coupling data\n');
    fprintf(fID, 'boundary info: num of points, start point\n');
    fprintf(fID, 'EAST\n\t-1\t\t1\n');
    fprintf(fID, 'WEST\n\t5\t\t1\n');
    fprintf(fID, 'SOUTH\n\t-1\t\t1\n');
    fprintf(fID, 'NORTH\n\t-1\t\t0\n');

    % Loop through each time step
    for step = 1:num_steps
        fprintf(fID,'\n\t%f', data.t(step));
        printside(fID, 'EAST', []);
        printside(fID, 'WEST', [data.u(step), data.v(step), data.eta(step)]);
        printside(fID, 'SOUTH', []);
        printside(fID, 'NORTH', []);
    end

    % Close the file
    fclose(fID);

    disp('Finished!');
    fprintf('NOTE: This coupling file starts at time = %f sec\n', data.t(1));
    fprintf('      ends at time = %f sec\n', data.t(end));

    %% PRINTSIDE
        function printside(FID, DIR, sidevar)
            fprintf(FID, ['\n' DIR ' SIDE']);
            if ~isempty(sidevar)
                for val = sidevar
                    fprintf(FID, '\n%16.6E', val);
                end
            end
        end

    end


