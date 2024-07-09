

function Validate_All_7_7(super_path,run_name)
    %{
    Validate_All_7_7
        More or less just repeat the time_spectra_a trial to validate FUNWAVE for all
        the trials of the Dune3 Dataset, from 5-24
    %}

    %% Naming/Setup
        % Make directories for the run
            make_FW_dirs(super_path,run_name);
            p = list_FW_dirs(super_path,run_name);

    %% Common Parameters for each Trial
        template = FW_WK_TIME_SERIES(); % use the time series template
        DX = 0.25;                      % use a constant DX: adjust as needed
        template.DX = DX;
        template.CFL = 0.4;
        template.GammaTMA = 3.3;
        template.PLOT_INTV = 0.05;  % Adjust as needed
        template.TOTAL_TIME = 1400; % Adjust as needed

    %% Loop through all trials
        num_i = 5; % first trial number
        num_f = 24; % last trial number
        tri = 1; % iteration counter
        all_inputs = struct(); % large structure to store all to

        for num = num_i:num_f
        %% Bathymetry and Spectra for Each Trial
            % Get the data from each trial
                Trial = load("/work/thsu/rschanta/RTS/data/D3a.mat",['Trial',sprintf('%02d',num)]);
                Trial = Trial.(['Trial',sprintf('%02d',num)]);
            % Make the bathymetry for each trial for a specified DX
                bathy = prep_D3_bathy_6_21(Trial,DX)
            % Get the spectra for each trial
                time_series = [Trial.filtered_data.t, Trial.filtered_data.eta(:,1)];
                % Parameters
                    lo = 0.1; % lowest frequency resolved
                    hi = 2;   % highest frequency resolved
                    sc = 0.01; % scaling factor (ignore)
                spectra_time_series = get_TS_spectra(time_series,lo,hi,sc);
            
        %% Feed bathymetry/spectra data into template
                input = template; % copy of template
            % Bathymetry
                input.files.bathy = bathy;
                input.Mglob = int64(size(bathy.bathy_file, 2));
                input.Nglob = int64(size(bathy.bathy_file, 1));
            % Spectra/Wavemaker
                input.files.spectra = spectra_time_series;
                input.PeakPeriod = spectra_time_series.PeakPeriod;         
                input.NumWaveComp = spectra_time_series.NumWaveComp; 
                input.Xc_WK = bathy.array(1,1);
                input.DEP_WK = bathy.array(1,2);

        %% Feed ID Information into template
            % Paths/names associated with trial
                ptr = list_FW_tri_dirs(tri,p);
                input.TITLE = ptr.input_name;
                input.DEPTH_FILE = ptr.b_file;
                input.WaveCompFile = ptr.sp_file;
                input.RESULT_FOLDER = ptr.RESULT_FOLDER;

        %% Print required input files
            print_FW_in(input,ptr.i_file);
            print_FW_bathy(bathy,ptr.b_file);
            print_time_series_spectra(input.files.spectra,ptr.sp_file,0);
        
        %% Save to larger structure
            all_inputs.(ptr.num_str) = input;
        
        %% Plot domain and spectra
            plot_domain(input,ptr);
            plot_time_spectra(input,ptr);

        %% Proceed iteration
            tri = tri + 1;
        end

    %% Save all inputs to one larger structure, table, and parquet
        save_inputs(p,all_inputs);
    
end