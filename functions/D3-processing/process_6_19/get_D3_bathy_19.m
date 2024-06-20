%{
    -get_D3_bathy_6_19()
        Get the bathymetry for the Dune3 Data, taking into account the 
        suggestions from Tom/Fengyan to include the Dune portioon of the 
        data

    NOTES:
        this cuts to the first wave gage

%}



function bathy = get_D3_bathy_19(Trial,DX)
%% Arguments
%{
    - Trial: (structure) Dune3 data structure with the following fields
        - raw_data
        - filtered_data
        - wave_condition
    - DX: (double) grid spacing

    - bathy (structure)- Output structure with:
        - bathy_file (double array): Mglob x Nglob array for the dep file
        - array (double array): Nglob x 2 array for 1D profile
        - WGx_raw (double array): position of wave gages
%}
%% Get inputs
        bathy_raw = Trial.raw_data.bed_before;
        WG = Trial.raw_data.WG_loc_x;
        MWL = Trial.raw_data.MWL;
%% Cut to first wave gage
    WG1 = WG(1); % first wave gage on the left
    Redge = max(bathy_raw(:,1)); % furthest point to the right
    bathy_cut = cut_19(bathy_raw,[WG1 Redge],1,2);
%% Interpolate to DX with set MWL
        bathy_array = interp_Dune3_bathy_619(bathy_cut,DX,MWL);
   % Create file to print
        bathy_file = [bathy_array(:,2)'; bathy_array(:,2)'; bathy_array(:,2)'];
   % Outputs
        bathy.bathy_file = bathy_file;
        bathy.array = bathy_array;
        bathy.WGx_raw = WG;
end