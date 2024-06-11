function bathy3 = get_D3_bathy_D3_6_10(Trial,DX)
    %% Load in Relevant Variables
    %%% Experimental eta at 22 wave gauges
        % Position of gauges
            WGx_raw = Trial.raw_data.WG_loc_x;
            MWL = Trial.raw_data.MWL;
        % Bed x and height coordinates
            b_f_x = Trial.filtered_data.bed_num_before(:,1);
            b_f_z = Trial.filtered_data.bed_num_before(:,2);

    %% Test bathy making
        %%% Add on flat portion
        bathy1 = [b_f_x, b_f_z];
        %%% Cut bathymetry to between leftmost gauge and dry beach
        bathy2 = cut_bathy_610(bathy1, b_f_x, MWL);
        %%% Interpolate bathymetry to DX grid spacing
        bathy3 = interp2DX_610(bathy2,DX,MWL);
        bathy3 = [bathy3(:,2)'; bathy3(:,2)'; bathy3(:,2)'];
end