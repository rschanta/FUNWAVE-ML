%{
calc_skew_asym
    - calculates the skew and asymmetry for a time series of eta values at
      some specified start index
%}

function [skew, asy] = calc_skew_asym(eta,start_i)
%% Arguments
%{
    - eta: 1D time series of surface elevations
    - start_i: index to start calculation at
%}

%%% Initial Processing
    % Converts into row vector if not already
        eta = reshape(eta,1, []);
    % Cut out any dead time at the beginning
        eta = eta(start_i:end);
    % Subtract out mean
        eta_n = eta - mean(eta); % Subtract out mean

%%% Math for Skew and Asymmetry
    % Denominator for skew and asymmetry
        denom = (mean(eta_n.^2))^(1.5); 
    % Numerator for skew
        sk_num = mean(eta_n.^3);
    % Numerator for Asymmetry
        hn = imag(hilbert(eta_n));
        hnn = hn'-ones(length(eta_n),1)*mean(hn);
        asy_num = mean(hnn.^3);
    % Calculate and output
        skew = sk_num/denom;
        asy = asy_num/denom;
    
end