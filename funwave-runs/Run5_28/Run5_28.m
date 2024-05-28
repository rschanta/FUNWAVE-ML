%{
RUN SCRIPT

Run script for Run5_28
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
        FWS.Mglob = int64(500);
        FWS.Nglob = int64(3);
        FWS.CFL = 0.5;
        FWS.PLOT_INTV = 1;

    
%% List of variables to loop through
    r_S = linspace(0.04,0.1,2); % SLOPE
    r_T = linspace(4,12,2);      % PERIOD
    r_A = linspace(0.25,0.5,2);  % AMPLITUDE
    r_H = [4];
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
        % Package up loop variables and create parameters
            q.S = s; q.T = t; q.a = a; q.H = h;
            cv = create_params(q,input);
        % Set parameters
            input.DX = cv.DX;
            input.DY = cv.DX;
            input.Sponge_west_width = cv.SW;
            input.Xslp = cv.Xslp;
            input.Xc_WK = cv.WK;
            input.DEP_WK = h;
            input.DEPTH_FLAT = h;

    %%% PRINT INPUT AND STORE TO STRUCTURE
        % Print input file
            disp(['Generated Trial:',num2str(tri)]);
            print_FW_in(input,tpaths.input)   
        % Save to input structure
            all_inputs.(tpaths.input_name) = input;
         
tri = tri + 1;
end;end;end;end;

%% Save all inputs to one larger structure, table, and parquet
    %save(paths.input_sum_path,'-struct', 'all_inputs', '-v7.3')
    disp('Starting to save');
    save_inputs(paths,all_inputs);
    disp('Saved Big Input Summary');

%% Create Parameters Helper
function cv =  create_params(s,input)
    %%% Calculate wave number k and kh
        h = s.H;
        [k, L] = dispersion(s.T,h);
        kh = k*h;

    %%% FUNWAVE Stability Requirements
            %%% Stability Requirement 1: height/DX > 15
                DX_min = h/15;
            %%% Stability Requirement 2: 60 points per wavelength
                DX_max = L/60;
            %%% Choose in the middle
                DX = mean([DX_min DX_max]);
            %%% Resulting Xslp
                Mglob = double(input.Mglob);
                Xslp = Mglob*DX-h/s.S;
            %%% Set Sponge Width for stability
                SW = 0.52*L;
            %%% Set Wavemaker position for stability
                WK = 1.1*L; 
    %%% output relevant variables
        cv.DX = DX;
        cv.Xslp = Xslp;
        cv.L = L;
        cv.SW = SW;
        cv.WK = WK;

end

