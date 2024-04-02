%% Access helper functions
addpath(genpath('/work/thsu/rschanta/RTS/functions/'));

%% Name of the Run
run_name = mfilename;

%% Outermost Folder
super_path = '/lustre/scratch/rschanta/';

%% Make directories for run
    paths = mk_FW_dir(super_path,run_name);
    
%% Access Dune3 Data
    D3a = load('/work/thsu/rschanta/RTS/data/D3a.mat');

%% Get bathymetry and coupling data
    DX = 0.25;
    BC = D3_couple1(D3a,DX);

%% Make a FW input structure and set common parameters
FWS = FW_in_COUPLE();
    FWS.Nglob = int64(3);
    FWS.CFL = 0.35;
    FWS.DX = DX;
    FWS.TOTAL_TIME = 1399.9;
    FWS.PLOT_INTV = 0.01;

    
%% Loop through for all trials
all_inputs = struct();
for k = 5:24
    % Input naming
        trial = ['Trial',sprintf('%02d',k)];
        in_name= ['input_',trial];
        in_path= ['input_',trial,'.txt'];
        out_path = ['out_',trial,'/'];
        coupling_file = ['coupling_',trial,'.txt'];
        bathy_file = ['bathy',trial,'.txt'];
    % Coupling and Bathy Data
        BC_i = BC.(trial);
    % Set variables
        input = FWS;
            input.TITLE = in_name;
            input.Mglob = int32(length(BC_i.Bathy));
            input.COUPLING_FILE = fullfile(paths.coupling_path,coupling_file);
            input.DEPTH_FILE = fullfile(paths.bathy,bathy_file);
            input.RESULT_FOLDER = fullfile(paths.output_raw,out_path);
    % Set dependent parameters
            input.DY = DX;
            
    % Print input file
        inpath = fullfile(paths.inputs,in_path);
        print_FW_in(input,inpath)
        
    % Print Bathymetry File
        bdata = BC_i.Bathy;
        print_FW_bathy(bdata,input.DEPTH_FILE)
        
    % Print Coupling File
        cdata = BC_i.Coupling;
        print_FW_coupling(cdata,input.COUPLING_FILE)
        
    
        
    % Save to input structure
        all_inputs.(in_name) = input;
end


%% Save all inputs to one larger structure
inputs_name = fullfile(paths.run,'inputs.mat');
save(inputs_name,'-struct', 'all_inputs', '-v7.3')


