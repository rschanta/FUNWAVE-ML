%{
bathy_from_dep_flat
    - Takes a 'DEP_FLAT_SLOPE' model of FUNWAVE
    to return the bathymetry as a vector.
%}
function bathy = bathy_from_dep_flat(Mglob,FWS)
%% Arguments
%{
    - Mglob: (double) Mglob dimension (be careful integer/double)
    - FWS: (structure) FWS structure
%}
    D = FWS.DEPTH_FLAT;
    Xslp = FWS.Xslp;
    DX = FWS.DX;
    SLP = FWS.SLP;
    % Initialize Bathy array
        z = D*ones(1,Mglob);
    % Get indices of sloping portion
        indices = (floor(Xslp/DX)):Mglob;
    % Add onto portion
        z(indices) = D - SLP*(indices - floor(Xslp/DX))*DX;
    % Construct x axis
        x = (0:Mglob-1)*DX;
    % Construct output
        bathy.bathy_file = [z; z; z;]
        bathy.array = [x' z']
end

        