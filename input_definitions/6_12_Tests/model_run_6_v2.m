%{
function for debugging runs
%}

function model_run_6_v2(super_path,run_name)
    %{
    RUN SCRIPT

    Run a DEPTH_FLAT trial to test out animation and such
    %}

    %% Naming/Setup
        make_FW_dirs(super_path,run_name);
        p = list_FW_dirs(super_path,run_name);
    %% Template to use and common parameters
    temp = FW_in_SLP();
        temp.TOTAL_TIME = 600;
        temp.Mglob = int64(500);
        temp.Nglob = int64(3);
        temp.CFL = 0.5;
        temp.PLOT_INTV = 0.05;

    %% List of variables to loop through
    r_S = linspace(0.04,0.1,9); % SLOPE
    r_T = linspace(4,12,9);      % PERIOD
    r_A = linspace(0.25,0.5,9);  % AMPLITUDE
    r_H = 5;
        %%% Iteration Counter and Storage
            tri = 1; all_inputs = struct();
    
    %% Loop through variables
    for s = r_S; for t = r_T; for a = r_A; for h = r_H
            input = temp;
        %%% Get paths/names for trial
            ptr = list_FW_tri_dirs(tri,p);
        %%% SET LOOP VARIABLES
            input.TITLE = ptr.input_name;
            input.SLP = s;
            input.Tperiod = t;
            input.AMP_WK = a;
            input.RESULT_FOLDER = ptr.RESULT_FOLDER;
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
            % Back out bathymetry
                input.files.bathy = bathy_from_dep_flat(input)

            %%% PRINT INPUT AND STORE TO STRUCTURE
            % Print input file
                disp(['Saving input_',ptr.num_str,'.txt...']);
                print_FW_in(input,ptr.i_file);
                disp(['input_',ptr.num_str,'.txt successfully saved to',ptr.i_file]); 
            % Save to input structure
                all_inputs.(ptr.num_str) = input;
            % Plot Bathymetry 
                plot_domain(input,ptr)

            % Iterate
            tri = tri + 1;
        end;end;end;end;
                    

        
        

    %% Save all inputs to one larger structure, table, and parquet
        disp('Starting to save input summaries...');
        save_inputs(p,all_inputs);
        disp('Successfully saved input summaries!');

        
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

    function [k, L] = dispersion(T,h)
        sigma = 2*pi/T;
        g = 9.81;
        k = -fzero(@(k) sigma^2-g*k*tanh(k*h),0); 
        L = 2*pi/k;
    end
    

    
end