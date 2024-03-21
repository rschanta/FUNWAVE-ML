%% Access helper functions
addpath(genpath('/work/thsu/rschanta/RTS/functions/'));

%% Name of the Run
run_name = mfilename;

%% Outermost Folder
super_path = '/lustre/scratch/rschanta/';

%% Make directories for run
    paths = mk_FW_dir(super_path,run_name);
    

%% Make a FW input structure and set common parameters
FWS = FW_in_SLP();
    FWS.TOTAL_TIME = 200;
    FWS.Mglob = int64(1024);
    FWS.Nglob = int64(3);
    FWS.CFL = 0.35;
    FWS.PLOT_INTV = 0.01;

    
%% List of variables to loop through
    r_S = linspace(0.05,0.1,10); % SLOPE
    r_T = linspace(3,12,10);      % PERIOD
    r_A = linspace(0.25,1.25,9);  % AMPLITUDE
    r_H = 7;
    % Iteration Counter and Storage
    iter = 1; all_inputs = struct();

for s = r_S; for t = r_T; for a = r_A; for h = r_H
    % Input naming
        no = sprintf('%05d',iter);
        in_name= ['input_',no];
        in_path= ['input_',no,'.txt'];
        out_path = ['out_',no,'/'];
    % Set variables
    input = FWS;
        input.TITLE = in_name;
        input.SLP = s;
        input.Tperiod = t;
        input.AMP_WK = a;
        input.RESULT_FOLDER = fullfile(paths.output_raw,out_path);
    % Set dependent parameters
        q.S = s; q.T = t; q.a = a; q.H = h;
        cv = create_params(q,input);
            input.DX = cv.DX;
            input.DY = cv.DX;
            input.Sponge_west_width = cv.SW;
            input.Xslp = cv.Xslp;
            input.Xc_WK = cv.SW;
            input.DEP_WK = h;
            input.DEPTH_FLAT = h;
    % Print input file
        inpath = fullfile(paths.inputs,in_path);
        print_FW_in(input,inpath)
        
    % Save to input structure
        all_inputs.(in_name) = input;
         
iter = iter + 1;
end;end;end;end;

%% Save all inputs to one larger structure
inputs_name = fullfile(paths.run,'inputs.mat');
save(inputs_name,'-struct', 'all_inputs', '-v7.3')

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
