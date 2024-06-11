
%{
get_D3_spectra
    - prepares spectra from Dune 3 data
%}
function spectra_1D = get_D3_spectra(df,n_bins,f_max)
    %% Arguments
    %{
        - df: (struct) structure from a Dune 3 trial containing:
            - raw_data
            - filtered_data
            - wave_condition

        - n_bins: (double) number of frequency bins to use

        - f_max: (double) highest frequency to include
    %}
    
    %%% Times
        t = df.filtered_data.t;
        t0 = df.filtered_data.t0;            % Start time
        tend = df.filtered_data.t_end;       % End time
        tvec = [t0 tend];                         % [Start End]
    %%% Get eta and eta incident
        eta = df.filtered_data.eta(:,1);     % Eta as-is
        eta_i = df.filtered_data.eta_i(:,1); % Incident eta
    %%% Package together and cut
        t_eta = [t, eta];
        t_eta_i = [t, eta_i];
        t_eta = cut(t_eta,tvec,1,2);
        t_eta_i = cut(t_eta_i,tvec,1,2);
    %% Get amplitude spectrum
    %%% Parameters
        dt = t(2)-t(1);         % time step       
        N = length(t_eta(:,1)); % length of signal
        fs = 1/dt;              % sample frequency
        df = 1/(N*dt);          % frequency resolution
    %%% Frequency axis
        f = 0:df:(fs-df);       % frequency up to 
        f = f(1:floor(N/2))';          % Symmetry: just take first half
    %%% Calculate spectrum
        S = 2*1i/N*fft(eta);     % Take FFT and scale
        S = S(1:floor(N/2));           % Symmetry: just take first half
    %% Process spectra further
    %%% Cut out highest frequency
        spectra = [f S];                      % Package as-is 
        spectra = cut(spectra,[0 f_max],1,2); % Cut out to below f_max
        f = spectra(:,1);
        S = abs(spectra(:,2));                % Magnitude of spectrum
    %%% Bins and bin width
        f_width = f_max/n_bins;                   % Width in Hz
        [~, f_width_i] = min(abs(f - f_width));   % Width in indices
    %%% Binning Procedure
        n_chunks = floor(numel(f) / f_width_i);   % number of data chunks
        S_binned = zeros(1, n_chunks + 1);        % Binned spectrum
        % Loop through all chunks and sum up
        for i = 1:n_chunks
            start_i = (i - 1) * 31 + 1;
            end_i = min(i * 31, length(f));
            S_binned(i) = sum(S(start_i:end_i));
        end
        f_binned = f(1:f_width_i:end);            % Binned Frequencies
        f_binned = f_binned + f_binned(2)/2;      % Adjust to midpoints     

    %% Package up into structure
        spectra_1D = struct();
        spectra_1D.f = f_binned;
        spectra_1D.S = S_binned;
        [~, id] = max(S_binned);
        spectra_1D.maxT = 1/spectra_1D.f(id);
end