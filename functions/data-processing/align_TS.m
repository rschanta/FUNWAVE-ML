%{
    align_TS
        - July 7th 2024
        - combines the timesteps from two time series into one such 
            that all the time steps in each original series are 
            represented, using the value at the last known time step if it 
            does not exist. This is useful for creating animations to
            ensure that the timesteps line up correctly

        - Example: let the first row of each be times, and the second row
            values of some variable:

            df1 = [1.0 2.0 2.5 3.0 3.1;
                   1.0 2.0 3.0 4.0 5.0]; 
            df2 = [1.5 2.0 2.6 2.9 3.2 5.0;
                   6.0 7.0 8.0 9.0 0.0 0.5]; 

            The combined series for each would be:

            dfc1 = [1.0 1.5 2.0 2.5 2.6 2.9 3.0 3.1 3.2 5.0;
                    1.0 1.0 2.0 3.0 3.0 3.0 4.0 5.0 5.0 5.0]  
            dfc2 = [1.0 1.5 2.0 2.5 2.6 2.9 3.0 3.1 3.2 5.0;
                   NaN  6.0 7.0 7.0 8.0 9.0 9.0 9.0 0.0 0.5];

            
            Note how the first row for each is now the same (since the
            times are combined) and the second rows "fills in the gaps"
            where there's not data at the corresponding time step for each
            series by using the last known value


        
    
%}

function dfc=  align_TS(df1,df2)
    %% Arguments
    %{
        - df1: (structure) structure for the first time series with the
            following fields:
            - t (n x 1 array): array of time steps
            - val (n x b): array of values at the time steps
        - df2: (structure) structure for the first time series with the
            following fields:
            - t (m x 1 array): array of time steps
            - val (m x b): array of values at the time steps
    
        - dfc: (structure) structure for the combined series with fields:
            - t (mn x 1 array, duplicates removed): array of time steps combined
            - val1 (same dim as t x b): array of values from df1 at time steps
            - val2 (same dim as t x c): array of values from df2 at time steps
    %}
    
        % Merge time series and pull out unique time steps
            t = unique(sort([df1.t; df2.t]));
    
        % Initialize merged time series with NaN values:
            val1 = zeros(size(t,1), size(df1.val, 2));
            val2 = zeros(size(t,1), size(df2.val, 2));
    
        % Fill in gaps in val1 with last known value for val1
        for i = 1:length(t)
            t_i = t(i);
            idx = find(df1.t <= t_i, 1, 'last');
            if ~isempty(idx)
                val1(i,:) = df1.val(idx,:);
            end
        end
    
        % Fill in gaps in val1 with last known value for val2
        for i = 1:length(t)
            t_i = t(i);
            idx = find(df2.t <= t_i, 1, 'last');
            if ~isempty(idx)
                val2(i,:) = df2.val(idx,:);
            end
        end
    
        % Output to struct
            dfc.t = t;
            dfc.val1 = val1;
            dfc.val2 = val2;
    end