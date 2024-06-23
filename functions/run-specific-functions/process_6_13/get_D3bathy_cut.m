function bathy = get_D3bathy_cut(Trial,DX)
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
        bathy_cut = cut_D3bathy_2(bathy_raw, b_f_x, MWL);
        %%% Interpolate bathymetry to DX grid spacing
        bathy_array = interpD3bathy(bathy_cut,DX,MWL);
        bathy_file = [bathy_array(:,2)'; bathy_array(:,2)'; bathy_array(:,2)'];
    %% Put into structure
        bathy.bathy_file = bathy_file;
        bathy.array = bathy_array;
        bathy.WGx_raw = WGx_raw;
        bathy.WGx_filt = WGx_filt;


        function bathy_cut = cut_D3bathy_2(bathy,WG, MWL)
            %% Arguments
            %{
                - bathy (N x 2 array): bathymetry from `bed_before` variable of 
                  Dune3 dataset
                - WG: (1 x M array): wave gauge positions in X
                - MWL: (1 x M array): MWL x locations from Dune3 dataset, where
                    NaN values correspond to on-land values
            %}
            
            %% Find where the NaN occurs (note- MWL must be column for isnan)
                [dry_WG_i, ~] = find(isnan(MWL'), 1, 'first');
                dry_WG_x = WG(dry_WG_i);
            %% Cut bathymetry to be between leftmost wave gauge and dry beach
                bathy_cut = cutD3(bathy,[WG(2),63],1,2);
            end
            
end