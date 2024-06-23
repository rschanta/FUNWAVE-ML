

function time_spectra_a(super_path,run_name)
    %{
    time_spectra_a


    %}

    %% Naming/Setup
        % Make directories for the run
            make_FW_dirs(super_path,run_name);
            p = list_FW_dirs(super_path,run_name);

    %% Load in Data for Trial 5
        num = 5;
            Trial = load("/work/thsu/rschanta/RTS/data/D3a.mat",['Trial',sprintf('%02d',num)]);
            Trial = Trial.(['Trial',sprintf('%02d',num)]);

    %% Make Bathymetry
        DX =0.25;
        bathy = prep_D3_bathy_6_21(Trial,DX)
    %% Make Spectra
        % Filtered data lefthand boundary time series
            time_series = [Trial.filtered_data.t, Trial.filtered_data.eta(:,1)];
        % Parameters
            lo = 0.1;
            hi = 2;
            sc = 0.01;
        % Function call
            spectra_time_series = get_TS_spectra(time_series,lo,hi,sc);


    get_TS_spectra(time_series,lo,hi,sc)
    %% Set common parameters
        template = FW_WK_TIME_SERIES(); 
            % Run Time/Plotting   
                template.DX = DX;
            % Numerics
                template.CFL = 0.4;
            % Common Wavemaker Traits
                template.GammaTMA = 3.3;

    %% Case 1: Short Run, low resolution
        temp1 = template;
            % Bathymetry
                temp1.files.bathy = bathy;
                temp1.Mglob = int64(size(bathy.bathy_file, 2));
                temp1.Nglob = int64(size(bathy.bathy_file, 1));
            % Spectra/Wavemaker
                temp1.files.spectra = spectra_time_series;
                temp1.PeakPeriod = 9.9;
                temp1.NumWaveComp = int64(2963);
                temp1.Xc_WK = bathy.array(1,1);
                temp1.DEP_WK = bathy.array(1,2);





    % Iteration Counter and Storage
    tri = 1; all_inputs = struct();


    %{
        6

    %}
    for t_time = [100, 600, 1450]; for freq = [0.1, 0.01]
        %%% Get paths/names for trial
            ptr = list_FW_tri_dirs(tri,p);
        %%% MAKE FWS STRUCTURE AND SET INPUTS
            input = temp1
            input.PLOT_INTV = freq;
            input.TOTAL_TIME = t_time;

            % File names & Strings
                input.TITLE = ptr.input_name
                input.DEPTH_FILE = ptr.b_file;
                input.WaveCompFile = ptr.sp_file;
                input.RESULT_FOLDER = ptr.RESULT_FOLDER;

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
                print_time_series_spectra(input.files.spectra,ptr.sp_file,0);
                disp(['spectra_',ptr.num_str,'.txt successfully saved to',ptr.sp_file]); 
            % Save to input structure
                all_inputs.(ptr.num_str) = input;
            % Plot Bathymetry and spectra
                plot_domain(input,ptr)
            
    tri = tri + 1;
    end; end;

    %% Save all inputs to one larger structure, table, and parquet
        disp('Starting to save input summaries...');
        save_inputs(p,all_inputs);
        disp('Successfully saved input summaries!');
    
end