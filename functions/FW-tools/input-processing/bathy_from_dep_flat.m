%{
bathy_from_dep_flat
    - Takes a 'DEP_FLAT_SLOPE' model of FUNWAVE
    to return the bathymetry as a vector.
%}
function bathy = bathy_from_dep_flat(FW)
    DEPTH_FLAT = FW.DEPTH_FLAT;
    SLP = FW.SLP;
    Xslp = FW.Xslp;
    DX = FW.DX;
    Mglob = double(FW.Mglob);
    x_axis = (0:double(Mglob)-1)*DX;
    % Number of grid points in Xslp
        Xslpi = round(Xslp/DX);
    % Elevation in Xslp
        z_flat = DEPTH_FLAT*ones(1,Xslpi);
    % Number of frid points along slant
        z_slant = -SLP*((Xslpi+1:Mglob)-Xslpi)*DX + DEPTH_FLAT;
    % Combine
        z_axis = [z_flat,z_slant];
        bathy = struct();
        bathy.array =  [x_axis' z_axis'];
    end
        