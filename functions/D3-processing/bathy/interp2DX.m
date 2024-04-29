%{
bathy_interp
    - interpolates Dune3 2D bathymetry data to some given DX resolution and
      subtracts off the MWL to get the depth instead of height from bed
%}

function bathy_interp = interp2DX(bathy,DX,MWL)
%% Arguments
%{
    - bathy (n x 2 array) array of bathymetry data where column 1 is
      crossshore position and column 2 is height from the bed
    - DX: (double) desired grid spacing in X to interpolate to, will be set
          as DX in FUNWAVE. Choose something stable.
    - MWL: (1 x m array) array of MWL at wave gauges
%}
%% Get unprocessed X and h values
    X_raw = bathy(:,1);
    h_raw = bathy(:,2);
%% Convert h values to Z (depth) values through MWL
    MWL_mean = nanmean(MWL);
    Z_raw = MWL_mean - h_raw;
%% Shift X coordinates over so leftmost point is 0
    X_raw = X_raw - X_raw(1);
%% Remove any duplicates of X coordinates (this is an issue for some trials)
    [X, Z] = make_unique_X(X_raw,Z_raw);
%% Interpolate to Grid
    X_out = 0:DX:max(X);
    Z_out = interp1(X,Z,X_out,"linear");
%% Output in same form as input
    bathy_interp = [X_out' Z_out'];

end 