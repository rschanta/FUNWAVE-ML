%{
get_TS_spectra
    -DATE: June 19th 
    - Prepares a spectra file for the WK_TIME_SERIES option in funwave
%}



function spectra = get_TS_spectra(time_series,lo,hi,sc)
%% Arguments
%{
- time_series: (n x 2 double array)- array where the first column is
    the time series (starting from 0) and the second is eta
- lo: (double)- cutoff frequency on the low end
- hi: (double)- cutoff frequency on the high end
- sc: (double)- scale factor for final amplitudes
- spectra: (structure)- structure with the following fields:
    - per: (n x 1 array)- array of periods for wavemaker
    - cnn: (n x 1 array)- array of amplitudes for each period, unscaled
    - cnn_sc: (n x 1 array)- array of amplitudes for each period, scaled
    - enn: (n x 1 array)- array of phase shifts
    - fourier: (structure)- contains fourier coefficients directly
        - a0: (double)- first term
        - an: (n x 1 array) - cosine terms
        - bn: (n x 1 array) - sine terms
%}

%%% Get basic info
% Get time series and eta series
    t = time_series(:,1);     % time series
    t = t - min(t);           % force to start at 0
    dt = t(2) - t(1);         % time between samples
    eta = time_series(:,2);   % wave signal
% Length of series and first half
    m = length(eta); 
    M = floor((m+1)/2); 
%%% FFT and Processing
    d = fft(eta);
    t_length = dt*m;            % Length of time record
% Fourier Coefficients
    a0 = d(1)/m;            % First time
    an = 2*real(d(2:M))/m;  % Cosine coefficients
    bn = -2*imag(d(2:M))/m; % Sine coefficients
% Time/Indices in spectral space
    n = 1:length(an);
    x=[0:length(n)-1]*t_length/(length(n)-1);
% Amplitude and Phase
    cn = zeros(1,length(n)); en = zeros(1,length(n));
    for i=1:length(n)
        % Amplitude
        cn(i) = sqrt(an(i).^2+bn(i).^2);
        % Phase
        en(i) = atan2(bn(i),an(i));
    end

%%% Apply cutoff frequencies
icount=0; % count how many are kept in
for j=1:length(n)
    ff=j/t_length; % frequency of j-th harmonic
    if ff>lo && ff< hi
        icount=icount+1;
        % Period
        per(icount)=t_length/j;
        % Amplitude
        cnn(icount)=cn(j);
        % Phase
        enn(icount)=en(j);
    end
end

%%% Output to structure, include scale
    spectra.per = per;
    spectra.cnn = cnn;
    spectra.cnn_sc = sc*cnn;
    spectra.enn = enn;
    spectra.fourier.a0 = a0;
    spectra.fourier.an = an;
    spectra.fourier.bn = bn;
end
