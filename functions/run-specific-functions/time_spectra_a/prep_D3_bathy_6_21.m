%{
prep_D3_bathy_6_21
    - DATE: June 20th
    - Prepare Dune 3 bathymetry. Keeps interpolation all in here.
        Also uses the filtered data specifically.

%}
function bathy = prep_D3_bathy_6_21(Trial,DX)
disp('Started processing bathymetry...')
    %%% Get Inputs
         bathy_raw = Trial.filtered_data.bed_num_before;
         WGx_raw = Trial.raw_data.WG_loc_x;
         WGx_filt = Trial.filtered_data.loc_x;
         MWL = Trial.raw_data.MWL;
    %%% Interpolate to DX
            X_raw = bathy_raw(:,1); 
            h_raw = bathy_raw(:,2);
        % Shift X coordinates over so leftmost point is 0
            X_raw = X_raw - X_raw(1);
        % Convert h values to Z (depth) values through MWL
            MWL_mean = nanmean(MWL);
            Z_raw = MWL_mean - h_raw;
        % Remove any duplicates of X coordinates (this is an issue for some trials)
            uniqueValues = unique(X_raw);
            XZ_unique = [];
            % Add only first instance of unique x values
            for i = 1:length(uniqueValues)
                idx = find(X_raw == uniqueValues(i), 1, 'first');
                rowToAdd = [X_raw(idx), Z_raw(idx)];
                XZ_unique = [XZ_unique; rowToAdd];
            end
        % Interpolate to Grid
            X = XZ_unique(:,1); Z = XZ_unique(:,2);
            X_out = 0:DX:max(X);
            Z_out = interp1(X,Z,X_out,"linear");
    %%% Outputs
        % Prep outputs
            bathy_array = [X_out' Z_out'];
            bathy_file = [bathy_array(:,2)'; bathy_array(:,2)'; bathy_array(:,2)'];
        % Output to structure
            bathy.bathy_file = bathy_file;
            bathy.array = bathy_array;
            bathy.WGx_raw = WGx_raw;
            bathy.WGx_filt = WGx_filt;

    disp('Sucessfully processed bathymetry...')
    end