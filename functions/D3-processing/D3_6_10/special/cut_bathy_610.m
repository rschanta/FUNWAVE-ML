%{
cut_bathy
    - cuts a 1D bathymetry to not include any NaN values for Dune3
%}
function bathy_cut = cut_bathy(bathy,WG, MWL)
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
    bathy_cut = cut_610(bathy,[WG(1),63],1,2);
end
