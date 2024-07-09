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
disp('Started printing Bathymetry file...')
    try
    writematrix(data,path);
    catch
    writematrix(data.bathy_file,path);
    end

disp(['Bathymetry file successfully saved to: ',path]); 
end
