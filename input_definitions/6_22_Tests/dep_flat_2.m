function dep_flat_2(super_path,run_name)
    %{
    dep_flat_2
        - Test run for the new version of DEP_FLAT version


    %}

    %% Naming/Setup
        make_FW_dirs(super_path,run_name);
        p = list_FW_dirs(super_path,run_name);

    %% Set common parameters
        template = FW_in_SLP(); 
        template.TOTAL_TIME = 600; 
        template.PLOT_INTV = 0.01; 
        Mglob = 1024;

    %% Iteration Counter and Storage
    tri = 1; all_inputs = struct();
    tn = 10; an = 11; sn = 7; hn = 6;
    T = 7;  % linspace(3,12,tn);
    A = 0.36; % linspace(0.2,0.6,an);
    S = 0.1; % linspace(0.04,0.1,sn);
    H = [4 5]; % linspace(2,7,hn);

    %{
        Loop through different periods, amplitudes, slopes, 
        and water depths
    %}
    for t = T; for a = A; for s = S; for h = H
    % Test validity and proceed if so
        validity = FW_valid(t,h)

        if validity.valid == 0
            % Get paths/names for trial
            ptr = list_FW_tri_dirs(tri,p);
            % Make FWS Structure and set basic inputs
            input = template
                input.TITLE = ptr.input_name
                input.DEPTH_FILE = ptr.b_file;
                input.WaveCompFile = ptr.sp_file;
                input.RESULT_FOLDER = ptr.RESULT_FOLDER;
            % Loop variables
                input.Tperiod = t;
                input.AMP_WK = a;
                input.SLP = s;
                input.DEPTH_FLAT = h;
                input.DEP_WK = h;
            % Special care for Mglob
                input.Mglob = int64(Mglob)
            % Dynamic inputs dependent on loop variables
                input.Xc_WK = validity.WK; 
                input.Sponge_west_width = validity.SW; 
                DX = mean([validity.DX_low validity.DX_high]);
                input.DX = DX;
                input.DY = DX;
                input.Xslp = 0.75*Mglob*DX - h/s;
            % Add bathy to input
                bathy = bathy_from_dep_flat(Mglob,input)
                input.files.bathy = bathy;

            %%% PRINT INPUT AND STORE TO STRUCTURE
            % Print input file
                disp(['Saving input_',ptr.num_str,'.txt...']);
                print_FW_in(input,ptr.i_file);
                disp(['input_',ptr.num_str,'.txt successfully saved to',ptr.i_file]); 
            % Save to input structure
                all_inputs.(ptr.num_str) = input;
            % Plot Bathymetry and spectra
                plot_domain(input,ptr)

            % Proceed
            tri = tri + 1;
        end
        
    
    end; end; end; end;

    %% Save all inputs to one larger structure, table, and parquet
        disp('Starting to save input summaries...');
        save_inputs(p,all_inputs);
        disp('Successfully saved input summaries!');
    
end