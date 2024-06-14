

function C_Dune3(super_path,run_name)
    %{
    Agenda for 6_13 C_Dune3


        - Deal with the following cases:
            - Case 1: Couple at western edge using filtered data
                - Cons: no velocities here
                - Solution: set to 0?
            - Case 2: Couple at sensor at x = 21
                - Case 2a: Cut off bathymetry
                - Case 2b: Leave as is
    %}

    %% Naming/Setup
        % Make directories for the run
            make_FW_dirs(super_path,run_name);
            p = list_FW_dirs(super_path,run_name);
    %% Load in Data for Trial 5
        num = 5;
            Trial = load("/work/thsu/rschanta/RTS/data/D3a.mat",['Trial',sprintf('%02d',num)]);
            Trial = Trial.(['Trial',sprintf('%02d',num)]);

    %% Bathymetry for different cases
        DX = 0.25;
        % Bathymetry cut to sensor one.
        
        

    %% Coupling files
        coupling_L = get_coupling_613(Trial,1); % left-most sensor
        coupling_21 = get_coupling_613(Trial,2)

    %% COMMON PARAMETERS
        temp = FW_in_COUPLE();
            temp.TOTAL_TIME = 85;
            temp.PLOT_INTV = 0.01;
            temp.DX = DX;
            temp.WAVEMAKER = 'COUPLING';
    
    %% Special parameters
        temp_1 = temp
            bathy = get_D3bathy(Trial,DX); % Case 1 and 2
            temp_1.files.coupling = coupling_L;
            temp_1.files.bathy = bathy
            temp_1.Mglob = int64(253)
            temp_1.Nglob = int64(size(bathy.bathy_file, 1));
        temp_2 = temp
            bathy = get_D3bathy_cut(Trial,DX); % Case 1 and 2
            temp_2.files.coupling = coupling_21;
            temp_2.files.bathy = bathy
            temp_2.Mglob = int64(169)
            temp_2.Nglob = int64(size(bathy.bathy_file, 1));


    % Iteration Counter and Storage
    tri = 1; all_temps = struct();


    %{
        % CASE 3: Loop through each case

    %}
    for cond = [0 1]
        %%% Get paths/names for trial
            ptr = list_FW_tri_dirs(tri,p);
        %%% MAKE FWS STRUCTURE AND SET tempS
            if cond == 0
                input = temp_1;
            elseif cond == 1
                input = temp_2;
            end

                % File names & Strings
                    input.TITLE = ptr.input_name
                    input.DEPTH_FILE = ptr.b_file;
                    input.RESULT_FOLDER = ptr.RESULT_FOLDER;
                    input.Sponge_west_width = 0;;
                    input.COUPLING_FILE = ptr.c_file
                    

        %%% PRINT temp AND STORE TO STRUCTURE
            % Print temp file
                disp(['Saving temp_',ptr.num_str,'.txt...']);
                print_FW_in(input,ptr.i_file);
                disp(['temp_',ptr.num_str,'.txt successfully saved to',ptr.i_file]); 
            % Print bathymetry
                disp(['Saving bathy_',ptr.num_str,'.txt...']);
                print_FW_bathy(input.files.bathy,ptr.b_file);
                disp(['bathy_',ptr.num_str,'.txt successfully saved to',ptr.b_file]); 
            % Print coupling file
                disp(['Saving coupling_',ptr.num_str,'.txt...']);
                print_FW_coupling(input.files.coupling,ptr.c_file);
                disp(['coupling_',ptr.num_str,'.txt successfully saved to',ptr.c_file]); 
            % Save to temp structure
                all_temps.(ptr.num_str) = input;
            % Plot Bathymetry and spectra
                plot_domain(input,ptr)
            
    tri = tri + 1;
    end;



    %% Save all temps to one larger structure, table, and parquet
        disp('Starting to save temp summaries...');
        save_inputs(p,all_temps);
        disp('Successfully saved temp summaries!');
    
end