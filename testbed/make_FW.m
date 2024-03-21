


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
% 

% % Outputs to 'Single' Directory
% base = ['/lustre/scratch/rschanta/Multiple/',name,'/'];
% base_out = [base,'out/'];
% 
% %% Construct a default input and change the common parameters
% addpath("../../../FW-Inputs/"); % add path to FW_input class
% 
% %% Construct path for FW input structures, make folder
% prin_dir = [base,'prin/'];
% if ~exist(prin_dir, 'dir'); mkdir(prin_dir); end
% 
% %% Variables to Edit
%     r_S = linspace(0.05, 0.1,11); % Slope
%     r_T = linspace(3, 12,10);     % Period
%     r_A = linspace(0.1,0.55,11);  % Amplitude
%     r_H = 3;
% %% Edit Basic Template 
% % Things that can be changed without needing to consider stability
% template = FW_input('Template');
%     template.edit('TOTAL_TIME',400);
%     template.edit('DEPTH_TYPE','SLOPE');
%     template.edit('Mglob',int64(1024));
%     template.edit('FIELD_IO_TYPE','BINARY');
%     template.edit('CFL',0.2);
%     template.edit('PLOT_INTV',0.2);
%     template.remove('DEPTH_FILE');
%     template.edit('DEPTH_OUT','T');
%     template.edit('MASK','F');
% %% Loop through other variables
% iter = 1;
% for S = r_S; for T = r_T; for A = r_A; for H = r_H
% % Parameters that may influence stability
%     input = template;
% % Package up loop variables
%     s.S = S; s.T = T; s.A = A; s.H = H;s.name = name;
% % Calculate/Create Parameters
%     cv = create_params(input,s,base);
%     disp(cv.kh)
% % Progress forward if kh is valid
%     if cv.kh < pi
%     % Change parameters of interest
%         input.set('TITLE',[name,'_',sprintf('%05d',1)])
%         input.set('Xslp',cv.Xslp);
%         input.set('AMP_WK',A);
%         input.set('SLP',S);
%         input.set('DX', cv.DX);
%         input.set('DY', cv.DX);
%         input.set('DEPTH_FLAT',H)
%         input.set('Sponge_west_width',cv.SW)
%         input.set('Xc_WK',cv.WK)
%         input.set('DEP_WK',H);
%         input.set('Tperiod',T);
%         input.set('RESULT_FOLDER',[base_out,'out_',sprintf('%05d',iter),'/'])
%     % Store other useful values
%         input.store('kh',cv.kh);
%         input.store('L',cv.L)
%         input.store('MB',cv.MB);
%         input.store('aN',cv.aN);
%         input.store('tN',cv.tN);
% 
%     % Write file
%         input.Name = ['input','_',sprintf('%05d',iter)];
%         input.print_input(fullfile([base,'/in/']));
%     % Store to structure
%         input_struct = struct(input);
%         input_struct_path = fullfile(prin_dir,['input_',sprintf('%05d',iter),'.mat']);
%         save(input_struct_path, "input_struct");
%         iter = iter + 1;
%     end
% end; end; end; end
% 
% %% Save the iteration value
% fileID = fopen(['../Misc-Workspace/', name, '_num_trials.txt'],'w');
% fprintf(fileID,num2str(iter-1));
% fclose(fileID);
% 
% function cv =  create_params(input,s,base)
%     %%% Calculate wave number k and kh
%         h = s.H;
%         [k, L] = dispersion(s.T,h);
%         kh = k*h;
%     %%% Nondimensionalize amplitude by depth of water
%         aN = s.A/h;
%     %%% Nondimensionalize T by shallow water wave period
%         tN = L/sqrt(9.81*h);
% 
%     %%% FUNWAVE Stability Requirements
%             %%% Stability Requirement 1: height/DX > 15
%                 DX_min = h/15;
%             %%% Stability Requirement 2: 60 points per wavelength
%                 DX_max = L/60;
%             %%% Choose in the middle
%                 DX = mean([DX_min DX_max]);
%             %%% Resulting Xslp
%                 Mglob = double(input.FW.Mglob);
%                 Xslp = Mglob*DX-h/s.S;
%             %%% Set Sponge Width for stability
%                 SW = 0.52*L;
%             %%% Set Wavemaker position for stability
%                 WK = 1.1*L;
%             %%% Resulting Profile Wifth
%                 Width = Mglob*DX;
%             %%% Resulting sloped portion (beach)
%                 Beach = Width - Xslp;
%             %%% Mglob in beach
%                 MB = Beach/DX;
% 
%     %%% output relevant variables
%         cv.DX = DX;
%         cv.Xslp = Xslp;
%         cv.kh = kh;
%         cv.Beach = Beach;
%         cv.MB = MB;
%         cv.L = L;
%         cv.aN = aN;
%         cv.tN = tN;
%         cv.SW = SW;
%         cv.WK = WK;
%     %%% Construct input.txt file name
%         cv.title = ['input_',s.name];
% 
%     %%% Construct RESULT_FOLDER name
%         output_name = ['out'];
%         RESULT_FOLDER = [fullfile(base,output_name),'/'];
%         RESULT_FOLDER = strrep(RESULT_FOLDER,'\','/');
%         cv.RESULT_FOLDER = RESULT_FOLDER;
% end
% 
% %% Function: Linear Dispersion Relation
% function [k, L] = dispersion(T,h)
%     sigma = 2*pi/T;
%     g = 9.81;
%     k = -fzero(@(k) sigma^2-g*k*tanh(k*h),0); 
%     L = 2*pi/k;
% end
