%{
    DEBUG Script
        This is a small FUNWAVE run of 4 trials at 50 seconds (1 second
        sampling) just for the purpose of debugging
%}

%% Path inputs
    super_path = '/lustre/scratch/rschanta/';

%% Naming/Setup
    % `run_name` from name of file
        run_name = mfilename;
    % Make directories for the run
        paths = mk_FW_dir(super_path,run_name);
    
%% Make a FW input structure and set common parameters
    FWS = FW_in_SLP();
        FWS.TOTAL_TIME = 50;
        FWS.Mglob = int64(1024);
        FWS.Nglob = int64(3);
        FWS.CFL = 0.5;
        FWS.PLOT_INTV = 1;

    
%% List of variables to loop through
    r_S = linspace(0.05,0.1,2); % SLOPE
    r_T = linspace(4,8,1);      % PERIOD
    r_A = linspace(0.25,0.5,2);  % AMPLITUDE
    r_H = 5;
    % Iteration Counter and Storage
    tri = 1; all_inputs = struct();

%% Loop through variables
for s = r_S; for t = r_T; for a = r_A; for h = r_H
    %%% GET PATHS FOR TRIAL
        tpaths = list_FW_tri_dirs(tri,paths);
    %%% SET LOOP VARIABLES
            input = FWS;
            input.TITLE = tpaths.input_name;
            input.SLP = s;
            input.Tperiod = t;
            input.AMP_WK = a;
            input.RESULT_FOLDER = tpaths.RESULT_FOLDER;

    %%% SET OTHER PARAMETERS DEPENDENT ON LOOP VARIABLES
            q.S = s; q.T = t; q.a = a; q.H = h; q.Mglob = input.Mglob;
            cv = create_params(q);
        % Set parameters
            input.DX = cv.DX;
            input.DY = cv.DX;
            input.Sponge_west_width = cv.SW;
            input.Xslp = cv.Xslp;
            input.Xc_WK = cv.SW;
            input.DEP_WK = h;
            input.DEPTH_FLAT = h;

    %%% PRINT INPUT AND STORE TO STRUCTURE
        % Print input file
            print_FW_in(input,tpaths.input)   
        % Save to input structure
            all_inputs.(tpaths.input_name) = input;
         
tri = tri + 1;
end;end;end;end;

%% Save all inputs to one larger structure, table, and parquet
    save_inputs(paths,all_inputs);


%% Create Parameters Helper
function cv =  create_params(q)
    %%% Calculate wave number k and kh
        h = q.H;
        W = LinDisp(q.T,'T',q.H);
        kh = W.k*h;

    %%% FUNWAVE Stability Requirements
            %%% Stability Requirement 1: height/DX > 15
                DX_min = h/15;
            %%% Stability Requirement 2: 60 points per wavelength
                DX_max = W.L/60;
            %%% Choose in the middle
                cv.DX = mean([DX_min DX_max]);
            %%% Resulting Xslp
                Mglob = double(q.Mglob);
                cv.Xslp = Mglob*cv.DX-h/q.S;
            %%% Set Sponge Width for stability
                cv.SW = 0.52*W.L;
            %%% Set Wavemaker position for stability
                cv.WK = 1.1*W.L;
end