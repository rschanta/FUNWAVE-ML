function bathy = get_D3bathy(Trial,DX)
    %% Load in Relevant Variables
    %%% Experimental eta at 22 wave gauges
        % Position of gauges
            WGx_raw = Trial.raw_data.WG_loc_x;
            WGx_filt = Trial.filtered_data.loc_x;
            MWL = Trial.raw_data.MWL;
        % Bed x and height coordinates
            b_f_x = Trial.filtered_data.bed_num_before(:,1);
            b_f_z = Trial.filtered_data.bed_num_before(:,2);
    %% Test bathy making
        %%% Add on flat portion
        bathy_raw = [b_f_x, b_f_z];
        %%% Cut bathymetry to between leftmost gauge and dry beach
        bathy_cut = cut_D3bathy(bathy_raw, b_f_x, MWL);
        %%% Interpolate bathymetry to DX grid spacing
        bathy_array = interpD3bathy(bathy_cut,DX,MWL);
        bathy_file = [bathy_array(:,2)'; bathy_array(:,2)'; bathy_array(:,2)'];
    %% Put into structure
        bathy.bathy_file = bathy_file;
        bathy.array = bathy_array;
        bathy.WGx_raw = WGx_raw;
        bathy.WGx_filt = WGx_filt;
end