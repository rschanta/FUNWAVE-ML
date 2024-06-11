function bathy = get_D3_bathy_X0U0V0(df,DX)
    %% Get data
        %%% Wave Gauge X locations and MWL at gauges
        WG = df.raw_data.WG_loc_x;
        MWL = df.raw_data.MWL;
    %%% Bathymetry from Bed before
        bathy = df.raw_data.bed_before;

    %%% Cut bathymetry to between leftmost gauge and dry beach
    bathy = cut_bathy(bathy, WG, MWL);
    %%% Add on flat portion
    bathy = [0, bathy(1,2); bathy];
    %%% Interpolate bathymetry to DX grid spacing
    bathy = interp2DX(bathy,0.25,MWL);
    %%% Arrange to Nglob by Mglob grid
    bathy = [bathy(:,2)'; bathy(:,2)'; bathy(:,2)'];
end