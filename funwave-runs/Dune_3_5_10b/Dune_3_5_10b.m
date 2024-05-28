%% Path inputs
    addpath(genpath('/work/thsu/rschanta/RTS/functions/'));
    super_path = '/lustre/scratch/rschanta/';

%% Naming/Setup
    % `run_name` from name of file
        run_name = mfilename;
    % Make directories for the run
        paths = mk_FW_dir(super_path,run_name);
    
%% Load in Dune3 Data
    D3a = load("/work/thsu/rschanta/RTS/data/D3a.mat");

%% Set up larger array 
    all_inputs = struct();

%% Loop through variables
for tri = 1:2
    %%% GET PATHS FOR TRIAL
        tpaths = list_FW_tri_dirs(tri,paths);

    %%% GET DATA FOR TRIAL
        df = D3a.(['Trial',sprintf('%02d',tri+4)]);

    %%% GET COUPLING FOR TRIAL
        coupling = get_D3_coupling(df);

    %%% GET BATHYMETRY FOR TRIAL, space set by DX
        DX = 0.25;
        bathy = get_D3_bathy(df,0.25);
    
    %%% GET DUNE3 TIME INFO
        
    %%% MAKE FWS STRUCTURE AND SET INPUTS
        input = FW_in_COUPLE();
            input.TITLE = tpaths.input_name;
            input.Mglob = int64(size(bathy, 2));
            input.Nglob = int64(size(bathy, 1));
            input.DX = DX;
            input.TOTAL_TIME = 1399.9;
            input.PLOT_INTV = 0.01;
            input.DEPTH_FILE = tpaths.bathy;
            input.COUPLING_FILE = tpaths.coupling;
            input.RESULT_FOLDER = tpaths.RESULT_FOLDER;
            input.files.bathy = bathy;
            input.files.coupling = coupling;
        
    %%% PRINT FILES AND STORE TO STRUCTURE
        % Print input file
            print_FW_in(input,tpaths.input)
        % Print coupling file
            print_FW_coupling(coupling,tpaths.coupling)
        % Print bathymetry file
            print_FW_bathy(bathy,tpaths.bathy)
        % Save to input structure
            all_inputs.(tpaths.input_name) = input;
         

end

%% Save all inputs to one larger structure
    save_inputs(paths,all_inputs);
