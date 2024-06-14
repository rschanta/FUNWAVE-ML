

function Spec_Dune3a(super_path,run_name)
    %{
    Agenda for 6_13 spectral_Dune3
        - Deal with the following cases:
            - Case 1a: Spectra defined by leftmost gage at position x=0 in filtered dataset
                      using `eta` variable under `LEFT_BC_IRR` wavemaker type
                        * LOOP through a few different sponge widths

            - Case 1b: Spectra defined by leftmost gage at position x=0 in filtered dataset
                      using `eta_i` variable under `LEFT_BC_IRR` wavemaker type
                        * LOOP through a few different sponge widths
            
            - Case 2a: Spectra defined by second gage at position x=21 in filtered dataset
                        using `eta` variable under `WK_DATA2D` wavemaker type
                        * LOOP through a few different sponge widths

            - Case 2b: Spectra defined by second gage at position x=21 in filtered dataset
                        using `eta_i` variable under `WK_DATA2D` wavemaker type
                        * LOOP through a few different sponge widths


                        ### SAVE FOR ANOTHER RUN
            - Case 2c: Spectra defined by second gage at position x=21 in filtered dataset
                        using `eta_i` variable under `JON_1D` wavemaker type
                
            - Case 2d: Spectra defined by second gage at position x=21 in filtered dataset
                        using `eta_i` variable under `TMA_1D` wavemaker type

            - Case 3a: Spectra defined by second gage at position x=21 in filtered dataset
                    using `eta` variable under `LEFT_BC_IRR` wavemaker type and artificially
                    cutting off the beach profile at this gage
            
            - Case 3b: Spectra defined by second gage at position x=21 in filtered dataset
                    using `eta_i` variable under `LEFT_BC_IRR` wavemaker type and artificially
                    cutting off the beach profile at this gage
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
        DX =0.4;
        bathy = get_D3bathy(Trial,DX); % Case 1 and 2
    %% Spectra for `eta` at x = 0 western edge
        spectra_eta_W = get_spectra_613(Trial,35,0.95,1,'eta'); % eta at western edge
        spectra_eta_i_W = get_spectra_613(Trial,35,0.95,1,'eta_i'); % eta_i at western edge
        spectra_eta_21 = get_spectra_613(Trial,35,0.95,2,'eta'); % eta at x = 21
        spectra_eta_i_21 = get_spectra_613(Trial,35,0.95,2,'eta_i'); % eta_i at x = 21;
    
    %% CASE 1 COMMON PARAMETERS
        temp_1 = FW_in_LEFT_BC_IRR();
            temp_1.TOTAL_TIME = 600; 
            temp_1.PLOT_INTV = 0.1; 
            temp_1.DX = DX;
            temp_1.GammaTMA = 3.3;
            temp_1.ThetaPeak = 0.0;
            temp_1.Ntheta = 0;
            temp_1.Sigma_Theta = 10.0;
            temp_1.CFL = 0.4;
            % BATHY
                temp_1.files.bathy = bathy;
                temp_1.Mglob = int64(size(bathy.bathy_file, 2));
                temp_1.Nglob = int64(size(bathy.bathy_file, 1));
                temp_1.DEP_WK = bathy.bathy_file(1,1);

            % CASE 1a: full eta
                temp_1a = temp_1;
                temp_1a.files.spectra = spectra_eta_W;
            % CASE 1b: just incident eta
                temp_1b = temp_1;
                temp_1b.files.spectra = spectra_eta_i_W;
    
    %% CASE 2 COMMON PARAMETERS
        temp_2 = FW_WK_DATA2D();    
            temp_2.TOTAL_TIME = 600; 
            temp_2.PLOT_INTV = 0.1; 
            temp_2.DX = DX;
            temp_2.GammaTMA = 3.3;
            temp_2.ThetaPeak = 0.0;
            temp_2.Ntheta = 0;
            temp_2.Sigma_Theta = 10.0;
            temp_2.CFL = 0.4;
            % BATHY
                temp_2.files.bathy = bathy;
                temp_2.Mglob = int64(size(bathy.bathy_file, 2));
                temp_2.Nglob = int64(size(bathy.bathy_file, 1));
                temp_2.Xc_WK = bathy.WGx_filt(2);
            % CASE 1a: full eta
                temp_2a = temp_2;
                temp_2a.files.spectra = spectra_eta_21;
                temp_2a.files.spectra = spectra_eta_21;
                temp_2a.PeakPeriod = spectra_eta_21.maxT;
                temp_2a.FreqPeak = spectra_eta_21.FreqPeak;
                temp_2a.FreqMin = spectra_eta_21.FreqMin;
                temp_2a.FreqMax = spectra_eta_21.FreqMax;
                temp_2a.Nfreq = spectra_eta_21.Nfreq;
            % CASE 1b: just incident eta
                temp_2b = temp_2;
                temp_2b.files.spectra = spectra_eta_i_21;
                temp_2b.PeakPeriod = spectra_eta_i_21.maxT;
                temp_2b.FreqPeak = spectra_eta_i_21.FreqPeak;
                temp_2b.FreqMin = spectra_eta_i_21.FreqMin;
                temp_2b.FreqMax = spectra_eta_i_21.FreqMax;
                temp_2b.Nfreq = spectra_eta_i_21.Nfreq;
                temp_2b.EqualEnergy='F';




    % Iteration Counter and Storage
    tri = 1; all_inputs = struct();


    %{
        % CASE 1: Loop through a few sponge widths

    %}
    for SWW = [0 1 2]; for cond = [0 1]
        %%% Get paths/names for trial
            ptr = list_FW_tri_dirs(tri,p);
        %%% MAKE FWS STRUCTURE AND SET INPUTS
            if cond == 0
                input = temp_1a;
            elseif cond == 1
                input = temp_1b;
            end

                % File names & Strings
                    input.TITLE = ptr.input_name
                    input.DEPTH_FILE = ptr.b_file;
                    input.WaveCompFile = ptr.sp_file;
                    input.RESULT_FOLDER = ptr.RESULT_FOLDER;
                % Loop variables
                    input.Sponge_west_width = SWW;
                    

        %%% PRINT INPUT AND STORE TO STRUCTURE
            % Print input file
                disp(['Saving input_',ptr.num_str,'.txt...']);
                print_FW_in(input,ptr.i_file);
                disp(['input_',ptr.num_str,'.txt successfully saved to',ptr.i_file]); 
            % Print bathymetry
                disp(['Saving bathy_',ptr.num_str,'.txt...']);
                print_FW_bathy(bathy,ptr.b_file);
                disp(['bathy_',ptr.num_str,'.txt successfully saved to',ptr.b_file]); 
            % Print spectra
                disp(['Saving spectra_',ptr.num_str,'.txt...']);
                print_1D_spectra(input.files.spectra,ptr.sp_file);
                disp(['spectra_',ptr.num_str,'.txt successfully saved to',ptr.sp_file]); 
            % Save to input structure
                all_inputs.(ptr.num_str) = input;
            % Plot Bathymetry and spectra
                plot_domain_and_spectra(input,ptr)
            
    tri = tri + 1;
    end; end;

    %{
        % CASE 2: Loop through a few sponge widths

    %}
    for SWW = [0 3 9 12 15]; for cond = [0 1]
        %%% Get paths/names for trial
            ptr = list_FW_tri_dirs(tri,p);
        %%% MAKE FWS STRUCTURE AND SET INPUTS
            if cond == 0
                input = temp_2a;
            elseif cond == 1
                input = temp_2b;
            end

                % File names & Strings
                    input.TITLE = ptr.input_name
                    input.DEPTH_FILE = ptr.b_file;
                    input.WaveCompFile = ptr.sp_file;
                    input.RESULT_FOLDER = ptr.RESULT_FOLDER;
                % Loop variables
                    input.Sponge_west_width = SWW;
                    

        %%% PRINT INPUT AND STORE TO STRUCTURE
            % Print input file
                disp(['Saving input_',ptr.num_str,'.txt...']);
                print_FW_in(input,ptr.i_file);
                disp(['input_',ptr.num_str,'.txt successfully saved to',ptr.i_file]); 
            % Print bathymetry
                disp(['Saving bathy_',ptr.num_str,'.txt...']);
                print_FW_bathy(bathy,ptr.b_file);
                disp(['bathy_',ptr.num_str,'.txt successfully saved to',ptr.b_file]); 
            % Print spectra
                disp(['Saving spectra_',ptr.num_str,'.txt...']);
                print_1D_spectra(input.files.spectra,ptr.sp_file);
                disp(['spectra_',ptr.num_str,'.txt successfully saved to',ptr.sp_file]); 
            % Save to input structure
                all_inputs.(ptr.num_str) = input;
            % Plot Bathymetry and spectra
                plot_domain_and_spectra(input,ptr)
            
    tri = tri + 1;
    end; end;


    %% Save all inputs to one larger structure, table, and parquet
        disp('Starting to save input summaries...');
        save_inputs(p,all_inputs);
        disp('Successfully saved input summaries!');
    
end