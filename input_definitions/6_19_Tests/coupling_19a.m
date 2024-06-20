

function coupling_19a(super_path,run_name)
    %{
    coupling_19a 1: RUN THE FOLLOWING CASES
        - CASE 1: Coupling using the cut off bathymetry from WG1 and ADV 2
                  for velocities as defined in `get_D3_bathy_19`. Try this
                  out with different ADV depths for velocity
                    
                - 1A: Uppermost ADV Gage at Position 1
                - 1B: Middle ADV Gage at Position 2
                    
        What's changed since last time:
            - extending beach to the actual dune itself
            - using 5 coupling cells at the boundary
            
        Other notes:
            - uses trial 5 data
    %}

    %% Naming/Setup
        % Make directories for the run
            make_FW_dirs(super_path,run_name);
            p = list_FW_dirs(super_path,run_name);
    %% Load in Data for Trial 5
        num = 5;
            Trial = load("/work/thsu/rschanta/RTS/data/D3a.mat",['Trial',sprintf('%02d',num)]);
            Trial = Trial.(['Trial',sprintf('%02d',num)]);

    %% Bathymetry for Data
        DX =0.25;
        bathy = get_D3_bathy_19(Trial,DX); % Case 1 and 2
    
    %% CASE 1 COMMON PARAMETERS
        c1 = FW_in_COUPLE();    
            c1.TOTAL_TIME = 1400; 
            c1.PLOT_INTV = 0.01; 
            c1.DX = DX;
            c1.DY = DX; 
            c1.CFL = 0.4;
            % BATHY
                c1.files.bathy = bathy;
                c1.Mglob = int64(size(bathy.bathy_file, 2));
                c1.Nglob = int64(size(bathy.bathy_file, 1));
            % CASE 1a: Uppermost ADV Gage
                c1a = c1;
            % CASE 1b: Middle ADV Gage
                c1b = c1;

    % Iteration Counter and Storage
    tri = 1; all_inputs = struct();
    %{
        2 conditions

    %}
    for cond = [0 1]
        %%% Get paths/names for trial
            ptr = list_FW_tri_dirs(tri,p);
        %%% MAKE FWS STRUCTURE AND SET INPUTS
            if cond == 0
                input = c1a;
                gage = 1;
            elseif cond == 1
                input = c1b;
                gage = 2;
            end

                % File names & Strings
                    input.TITLE = ptr.input_name;
                    input.DEPTH_FILE = ptr.b_file;
                    input.COUPLING_FILE = ptr.c_file;
                    input.RESULT_FOLDER = ptr.RESULT_FOLDER;
                % Different coupling possibilities
                    coupling = get_D3_coupling_19(Trial,gage);

        %%% PRINT INPUT AND STORE TO STRUCTURE
            % Print input file
                disp(['Saving input_',ptr.num_str,'.txt...']);
                print_FW_in(input,ptr.i_file);
                disp(['input_',ptr.num_str,'.txt successfully saved to',ptr.i_file]); 
            % Print bathymetry
                disp(['Saving bathy_',ptr.num_str,'.txt...']);
                print_FW_bathy(bathy,ptr.b_file);
                disp(['bathy_',ptr.num_str,'.txt successfully saved to',ptr.b_file]); 
            % Print coupling
                disp(['Printing coupling file:',ptr.num_str,'.txt...']);
                print_FW_coupling_19(coupling,ptr.c_file);
                disp(['coupling_',ptr.num_str,'.txt successfully saved to',ptr.c_file]); 
            % Save to input structure
                all_inputs.(ptr.num_str) = input;
            % Plot Bathymetry and spectra
                plot_domain(input,ptr)
            
    tri = tri + 1;
    end



    %% Save all inputs to one larger structure, table, and parquet
        disp('Starting to save input summaries...');
        save_inputs(p,all_inputs);
        disp('Successfully saved input summaries!');
    
end