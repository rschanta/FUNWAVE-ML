function print_FW_bathy(data,path)
    disp('Started printing bathymetry file')
    writematrix(data,path)
    disp('Finished printing bathymetry file')
end
