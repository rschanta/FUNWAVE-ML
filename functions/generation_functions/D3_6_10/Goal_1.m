%{
function for debugging runs
%}

function Goal_1(super_path,run_name)
    %{
    RUN SCRIPT

    Run script for Dune 3 X0U0V0 approach
    %}

    %% Path inputs
    super_path = '/lustre/scratch/rschanta';

    %% Naming/Setup
        % `run_name` from name of file
            run_name = mfilename;
        % Make directories for the run
            make_FW_dirs(super_path,run_name);
            p = list_FW_dirs(super_path,run_name);

    %% Load in Data for Trial 5
        num = 5;
            Trial = load("/work/thsu/rschanta/RTS/data/D3a.mat",['Trial',sprintf('%02d',num)]);
            
            Trial = Trial.(['Trial',sprintf('%02d',num)]);

        % Iteration Counter and Storage
        tri = 1; all_inputs = struct();

    %{
        First Ten Trials: Pure eta signal at left boundary, set velocities to 0.
        Use the bathymetry from the filtered dataset this time.

        Loop through several DX values
        %}
    for DX = linspace(0.05,0.5,10)

        %%% Get paths/names for trial
            ptr = list_FW_tri_dirs(tri,p);

        %%% GET COUPLING FOR TRIAL
            coupling = get_D3_coupling_D3_6_10(Trial);
            
        %%% GET BATHYMETRY FOR TRIAL, space set by DX
            bathy = get_D3_bathy_D3_6_10(Trial,DX);

        %%% MAKE FWS STRUCTURE AND SET INPUTS
            input = FW_in_COUPLE();
                input.TITLE = ptr.input_name;
                input.Mglob = int64(size(bathy, 2));
                input.Nglob = int64(size(bathy, 1));
                input.TOTAL_TIME = 1399.9;
                input.PLOT_INTV = 0.01;
                input.DX = DX;
                input.DEPTH_FILE = ptr.b_file
                input.COUPLING_FILE = ptr.c_file
                input.RESULT_FOLDER = ptr.RESULT_FOLDER
                input.files.bathy = bathy;
                input.files.coupling = coupling;

        %%% PRINT INPUT AND STORE TO STRUCTURE
            % Print input file
                disp(['Saving input_',ptr.num_str,'.txt...']);
                print_FW_in(input,ptr.i_file)  
                disp(['input_',ptr.num_str,'.txt successfully saved to',ptr.i_file]); 
            % Print bathymetry
                disp(['Saving bathy_',ptr.num_str,'.txt...']);
                print_FW_bathy(bathy,ptr.b_file);
                disp(['bathy_',ptr.num_str,'.txt successfully saved to',ptr.b_file]); 
            % Print coupling file
                disp(['Saving coupling_',ptr.num_str,'.txt...']);
                print_FW_coupling(coupling,ptr.c_file);
                disp(['coupling_',ptr.num_str,'.txt successfully saved to',ptr.c_file]); 
            % Print bathymetry
                disp(['Saving bathy_',ptr.num_str,'.txt...']);
                print_FW_bathy(bathy,ptr.b_file);
                disp(['bathy_',ptr.num_str,'.txt successfully saved to',ptr.b_file]); 
            % Save to input structure
                all_inputs.(ptr.num_str) = input;
            
    tri = tri + 1;
    end

    %{
        Next Ten Trials: Incident eta signal at left boundary, set velocities to 0.
        Use the bathymetry from the filtered dataset this time.

        Loop through several DX values
        %}
    for DX = linspace(0.05,0.5,10)

        %%% Get paths/names for trial
            ptr = list_FW_tri_dirs(tri,p);

        %%% GET COUPLING FOR TRIAL
            coupling = get_D3_coupling_D3_6_10_i(Trial);
            
        %%% GET BATHYMETRY FOR TRIAL, space set by DX
            bathy = get_D3_bathy_D3_6_10(Trial,DX);

        %%% MAKE FWS STRUCTURE AND SET INPUTS
            input = FW_in_COUPLE();
                input.TITLE = ptr.input_name;
                input.Mglob = int64(size(bathy, 2));
                input.Nglob = int64(size(bathy, 1));
                input.TOTAL_TIME = 1399.9;
                input.PLOT_INTV = 0.01;
                input.DX = DX;
                input.DEPTH_FILE = ptr.b_file
                input.COUPLING_FILE = ptr.c_file
                input.RESULT_FOLDER = ptr.RESULT_FOLDER
                input.files.bathy = bathy;
                input.files.coupling = coupling;

        %%% PRINT INPUT AND STORE TO STRUCTURE
            % Print input file
                disp(['Saving input_',ptr.num_str,'.txt...']);
                print_FW_in(input,ptr.i_file)  
                disp(['input_',ptr.num_str,'.txt successfully saved to',ptr.i_file]); 
            % Print bathymetry
                disp(['Saving bathy_',ptr.num_str,'.txt...']);
                print_FW_bathy(bathy,ptr.b_file);
                disp(['bathy_',ptr.num_str,'.txt successfully saved to',ptr.b_file]); 
            % Print coupling file
                disp(['Saving coupling_',ptr.num_str,'.txt...']);
                print_FW_coupling(coupling,ptr.c_file);
                disp(['coupling_',ptr.num_str,'.txt successfully saved to',ptr.c_file]); 
            % Print bathymetry
                disp(['Saving bathy_',ptr.num_str,'.txt...']);
                print_FW_bathy(bathy,ptr.b_file);
                disp(['bathy_',ptr.num_str,'.txt successfully saved to',ptr.b_file]); 
            % Save to input structure
                all_inputs.(ptr.num_str) = input;
                
        tri = tri + 1;
        end



    %% Save all inputs to one larger structure, table, and parquet
        disp('Starting to save input summaries...');
        save_inputs(p,all_inputs);
        disp('Successfully saved input summaries!');

    

    
end
