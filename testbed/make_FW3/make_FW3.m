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
    FWS.TOTAL_TIME = 5;
    
%% List of variables to loop through
    r_S = linspace(0.05,0.1,2); % SLOPE
    r_T = linspace(6,9,2);      % PERIOD
    r_A = linspace(0.2,0.5,2);  % AMPLITUDE
    
    % Iteration Counter and Storage
    iter = 1; all_inputs = struct();

for s = r_S; for t = r_T; for a = r_A
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
    % Print input file
        inpath = fullfile(paths.inputs,in_path);
        print_FW_in(input,inpath)
        
    % Save to input structure
        all_inputs.(in_name) = input;
         
iter = iter + 1;
end;end;end;

%% Save all inputs to one larger structure
inputs_name = fullfile(paths.run,'inputs.mat');
save(inputs_name,'-struct', 'all_inputs', '-v7.3')

