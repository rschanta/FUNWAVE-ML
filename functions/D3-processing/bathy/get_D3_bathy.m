%{
get_D3_bathy
    - prepares bathymetry from Dune3 data to create a 1D FUNWAVE simulation
%}
function bathy = get_D3_bathy(df,DX)
%% Arguments
%{
    - df: (struct) structure from a Dune 3 trial containing:
        - raw_data
        - filtered_data
        - wave_condition
    - DX: (double) desired grid spacing in X to interpolate to, will be set
          as DX in FUNWAVE. Choose something stable.
%}

%% Get data
    %%% Wave Gauge X locations and MWL at gauges
        WG = df.raw_data.WG_loc_x;
        MWL = df.raw_data.MWL;
    %%% Bathymetry from Bed before
        bathy = df.raw_data.bed_before;

%%% Cut bathymetry to between leftmost gauge and dry beach
    bathy = cut_bathy(bathy, WG, MWL);

%%% Interpolate bathymetry to DX grid spacing
    bathy = interp2DX(bathy,DX,MWL);
%%% Arrange to Nglob by Mglob grid
    bathy = [bathy(:,2)'; bathy(:,2)'; bathy(:,2)'];
end