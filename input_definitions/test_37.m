%{
function for debugging runs
%}

function test_37(super_path,run_name)
    %{
    RUN SCRIPT

    Add sigma theta, thetapeak, and other parameters
    %}

    %% Naming/Setup
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

        %}
    for DX = linspace(0.4,0.5,2)

        %%% Get paths/names for trial
            ptr = list_FW_tri_dirs(tri,p);
            
        %%% GET BATHYMETRY FOR TRIAL, space set by DX
            bathy = get_D3_bathy_D3_6_10(Trial,DX);

            % CHANGE TO INCIDENT ETA
        %%% GET SPECTRAL DATA FOR TRIAL, set n_bins and f_max
            spectra = get_D3_spectra_i(Trial,35,0.95);


        %%% MAKE FWS STRUCTURE AND SET INPUTS
            input = FW_in_LEFT_BC_IRR();
                input.TITLE = ptr.input_name;
                input.Mglob = int64(size(bathy, 2));
                input.Nglob = int64(size(bathy, 1));
                input.TOTAL_TIME = 60;
                input.PLOT_INTV = 1;
                input.DX = DX;
                input.DEPTH_FILE = ptr.b_file;
                input.WaveCompFile = ptr.sp_file;
                input.RESULT_FOLDER = ptr.RESULT_FOLDER;
                input.PeakPeriod = spectra.maxT;
                input.DEP_WK = bathy(1,1);
                input.files.bathy = bathy;
                %% NEW
                FreqPeak = 0.253;
                FreqMin = 0.01;
                FreqMax = 0.9;
                input.EqualEnergy='F';
                input.GammaTMA = 3.3;
                input.ThetaPeak = 0.0;
                input.Nfreq = 35;
                input.Ntheta = 0;
                input.Sigma_Theta = 10.0;
                %% NEW
                input.Hmo = 0.5761;

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
                print_1D_spectra(spectra,ptr.sp_file);
                disp(['spectra_',ptr.num_str,'.txt successfully saved to',ptr.sp_file]); 
            % Save to input structure
                all_inputs.(ptr.num_str) = input;
            
    tri = tri + 1;
    end

    %% Save all inputs to one larger structure, table, and parquet
        disp('Starting to save input summaries...');
        save_inputs(p,all_inputs);
        disp('Successfully saved input summaries!');

    

    
end