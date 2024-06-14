

function Spec_Dune3c(super_path,run_name)
    %{
    Agenda for 6_13 spectral_Dune3
        - Deal with the following cases:
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
        bathy = get_D3bathy_cut(Trial,DX); % Case 1 and 2
    %% Spectra for `eta` at x = 0 western edge
        spectra_eta_21 = get_spectra_613(Trial,35,0.95,2,'eta'); % eta at x = 21
        spectra_eta_i_21 = get_spectra_613(Trial,35,0.95,2,'eta_i'); % eta_i at x = 21;
    
    %% CASE 3 COMMON PARAMETERS
        temp_3 = FW_in_LEFT_BC_IRR();    
            temp_3.TOTAL_TIME = 600; 
            temp_3.PLOT_INTV = 0.1; 
            temp_3.DX = DX;
            temp_3.GammaTMA = 3.3;
            temp_3.ThetaPeak = 0.0;
            temp_3.Ntheta = 0;
            temp_3.Sigma_Theta = 10.0;
            temp_3.CFL = 0.4;
            % BATHY
                temp_3.files.bathy = bathy;
                temp_3.Mglob = int64(size(bathy.bathy_file, 2));
                temp_3.Nglob = int64(size(bathy.bathy_file, 1));
                temp_3.Xc_WK = bathy.WGx_filt(1);
            % CASE 3a: full eta
                temp_3a = temp_3;
                temp_3a.files.spectra = spectra_eta_21;
                temp_3a.files.spectra = spectra_eta_21;
                temp_3a.PeakPeriod = spectra_eta_21.maxT;
                temp_3a.FreqPeak = spectra_eta_21.FreqPeak;
                temp_3a.FreqMin = spectra_eta_21.FreqMin;
                temp_3a.FreqMax = spectra_eta_21.FreqMax;
                temp_3a.Nfreq = spectra_eta_21.Nfreq;
            % CASE 3b: just incident eta
                temp_3b = temp_3;
                temp_3b.files.spectra = spectra_eta_i_21;
                temp_3b.PeakPeriod = spectra_eta_i_21.maxT;
                temp_3b.FreqPeak = spectra_eta_i_21.FreqPeak;
                temp_3b.FreqMin = spectra_eta_i_21.FreqMin;
                temp_3b.FreqMax = spectra_eta_i_21.FreqMax;
                temp_3b.Nfreq = spectra_eta_i_21.Nfreq;
                temp_3b.EqualEnergy='F';




    % Iteration Counter and Storage
    tri = 1; all_inputs = struct();


    %{
        % CASE 3: Loop through a few sponge widths

    %}
    for SWW = [0 1 2]; for cond = [0 1]
        %%% Get paths/names for trial
            ptr = list_FW_tri_dirs(tri,p);
        %%% MAKE FWS STRUCTURE AND SET INPUTS
            if cond == 0
                input = temp_3a;
            elseif cond == 1
                input = temp_3b;
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