%{
    -get_D3_bathy_6_17()
        Get the bathymetry for the Dune3 Data, taking into account the 
        suggestions from Tom/Fengyan to include the Dune portioon of the 
        data

    -INPUTS
        -Trial (str): MATLAB structure of data for Dune3
        - DX (double): desired grid size
    -OUTPUTS
        - bathy (str): MATLAB structure with the following fields:
            - bathy_file: (Mglob x Nglob double): array that FUNWAVE prints
                to the bathy.txt file 
            - array: (Mglob x 2 double): array with first column x
                positions and second column z positions
            - WGx_raw: positions of raw wave gauge positions
            - WGx_filt: positions of filtered wave gauge positions

%}

function bathy = get_D3_bathy_6_17(Trial,DX)
   % Get inputs
        bathy_raw = Trial.filtered_data.bed_num_before;
        WGx_raw = Trial.raw_data.WG_loc_x;
        WGx_filt = Trial.filtered_data.loc_x;
        MWL = Trial.raw_data.MWL;
   % Interpolate to DX with set MWL
        bathy_array = interp_Dune3_bathy_617(bathy_raw,DX,MWL);
   % Create file to print
        bathy_file = [bathy_array(:,2)'; bathy_array(:,2)'; bathy_array(:,2)'];
   % Outputs
        bathy.bathy_file = bathy_file;
        bathy.array = bathy_array;
        bathy.WGx_raw = WGx_raw;
        bathy.WGx_filt = WGx_filt;
end
