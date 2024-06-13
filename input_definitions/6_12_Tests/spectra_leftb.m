%{
function for debugging runs
%}

function spectra_leftb(super_path,run_name)
    %{
    RUN SCRIPT

    Modify to use spectra at x = 21 and implement a sponge
    layer before of varying sizes

    What has changed:
        - Same as spectra_left, just less time to test out animation
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
        temp = FW_in_LEFT_BC_IRR();
            temp.TOTAL_TIME = 50; % CHANGED
            temp.PLOT_INTV = 1; % CHANGED
            temp.DX = 0.4;
            temp.GammaTMA = 3.3;
            temp.ThetaPeak = 0.0;
            temp.Ntheta = 0;
            temp.Sigma_Theta = 10.0;
            temp.CFL = 0.4;
    %% Spectra and bathymetry will be the same for all of them:
        bathy = get_D3bathy(Trial,temp.DX);
            temp.files.bathy = bathy;
            temp.Mglob = int64(size(bathy.bathy_file, 2));
            temp.Nglob = int64(size(bathy.bathy_file, 1));
            temp.DEP_WK = bathy.bathy_file(1,1);
    %% Spectra and bathymetry will be the same for all of them:
        spectra = get_spectra_at_21(Trial,35,0.95,1); % use filtered series
            temp.files.spectra = spectra;
            % temp.PeakPeriod = spectra.maxT;
            %temp.FreqPeak = spectra.FreqPeak;
            %temp.FreqMin = spectra.FreqMin;
            %temp.FreqMax = spectra.FreqMax;
            %temp.Nfreq = spectra.Nfreq;
            %temp.EqualEnergy='F';



    % Iteration Counter and Storage
    tri = 1; all_inputs = struct();
    %{
        % Loop through different sponge widths, equal energy, and sponge

    %}
    for SWW = linspace(0, 5, 5); for EE = [0 1]; for DS = [0 1]
        %%% Get paths/names for trial
            ptr = list_FW_tri_dirs(tri,p);
        %%% MAKE FWS STRUCTURE AND SET INPUTS
            input = temp;
                % File names & Strings
                    input.TITLE = ptr.input_name;
                    input.DEPTH_FILE = ptr.b_file;
                    input.WaveCompFile = ptr.sp_file;
                    input.RESULT_FOLDER = ptr.RESULT_FOLDER;
                % Loop variables
                    input.DIRECT_SPONGE =  char('F' + (DS == 1) * ('T' - 'F'));
                    input.EqualEnergy =  char('F' + (EE == 1) * ('T' - 'F'));
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
            % Plot Bathymetry and spectra
                plot_domain_and_spectra(input,ptr)
            
    tri = tri + 1;
    end; end; end

    %% Save all inputs to one larger structure, table, and parquet
        disp('Starting to save input summaries...');
        save_inputs(p,all_inputs);
        disp('Successfully saved input summaries!');

    

    
end