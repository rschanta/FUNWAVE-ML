%{
print_FW_bathy
    - prints a FUNWAVE bathymetry file from some array
%}
function print_FW_bathy(data,path)
%% Arguments
%{
    - data: (array) array Nglob x Mglob for bathymetry depths
    - path: (string) path to print to, including file name
%}
    disp('Started printing bathymetry file')
    writematrix(data,path)
    disp('Finished printing bathymetry file')
end
