%{
function for debugging runs
%}

function Spectra_at_21(super_path,run_name)
    %{
    RUN SCRIPT

    Modify to use spectra at x = 21 and implement a sponge
    layer before of varying sizes

    Try out the following wavemakers:
        - WK_DATA_2D

    Use the 
    %}

    %% Naming/Setup
        % Make directories for the run
            make_FW_dirs(super_path,run_name);
            p = list_FW_dirs(super_path,run_name);
    %% Load in Data for Trial 5
        num = 5;
            Trial = load("/work/thsu/rschanta/RTS/data/D3a.mat",['Trial',sprintf('%02d',num)]);
            Trial = Trial.(['Trial',sprintf('%02d',num)]);
    %% Template to use and common parameters
        temp = FW_WK_DATA2D();
            temp.TOTAL_TIME = 600;
            temp.PLOT_INTV = 0.01;
            temp.DX = 0.4;
            temp.GammaTMA = 3.3;
            temp.ThetaPeak = 0.0;
            temp.Ntheta = 0;
            temp.Sigma_Theta = 10.0;
            temp.Hmo = 0.55;


    % Iteration Counter and Storage
    tri = 1; all_inputs = struct();

    %{
        % Loop through different sponge widths

    %}
    for SWW = linspace(0, 20, 10)

        %%% Get paths/names for trial
            ptr = list_FW_tri_dirs(tri,p);
            
        %%% GET BATHYMETRY FOR TRIAL, space set by DX
            bathy = get_D3bathy(Trial,temp.DX);

        %%% GET SPECTRAL DATA FOR TRIAL, set n_bins and f_max
            spectra = get_spectra_at_21(Trial,35,0.95,2); % use filtered series

        %%% MAKE FWS STRUCTURE AND SET INPUTS
            input = temp;
                % File names & Strings
                    input.TITLE = ptr.input_name;
                    input.DEPTH_FILE = ptr.b_file;
                    input.WaveCompFile = ptr.sp_file;
                    input.RESULT_FOLDER = ptr.RESULT_FOLDER;
                % Bathymetry and spatial information
                    input.files.bathy = bathy;
                    input.Mglob = int64(size(bathy.bathy_file, 2));
                    input.Nglob = int64(size(bathy.bathy_file, 1));
                    input.DEP_WK = bathy.bathy_file(1,1);
                    input.Xc_WK = bathy.WGx_filt(2) % use filtered series
                % Spectral information
                    input.PeakPeriod = spectra.maxT;
                    input.FreqPeak = spectra.FreqPeak;
                    input.FreqMin = spectra.FreqMin;
                    input.FreqMax = spectra.FreqMax;
                    input.Nfreq = spectra.Nfreq;
                    input.EqualEnergy='F';
                % Sponge Information
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