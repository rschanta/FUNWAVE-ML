%{
linear_dispersion
    -DATE: June 20th
    - Calculate key hydrodynamic variables

%}

function W = linear_dispersion(val,param,h)
    %% Arguments
    %{
        - val (double): value of the parameter
        - param (string/char): one of four options:
            - 'k': wave number
            - 'omega': angular frequency
            - 'L': wavelength
            - 'T': period
        - h (double): depth of water
        - W (structure): contains hydrodynamic parameters
            - T = (double) period
            - omega = (double) angular frequency
            - L = (double) wavelength
            - k = (double) wave number
            - kh = (double) linearity parameter
    %}
    
    %%% Gravitational Constant and water height
        g = 9.81; % gravity
        W.h = h;
    
    %%% Case if given wavenumber k
        if strcmp(param, 'k')
            k = val;
            omega = sqrt(g*k*tanh(k*h));
            T = 2*pi/omega;
            L = 2*pi/k;
    %%% Case if given angular frequency omega
        elseif strcmp(param, 'omega')
            omega = val;
            T = 2*pi/omega;
            k = abs(fzero(@(k) omega^2-g*k*tanh(k*h),0));
            L = 2*pi/k;
    %%% Case if given wavelength
        elseif strcmp(param, 'L')
            L = val;
            k = 2*pi/L;
            omega = sqrt(g*k*tanh(k*h));
            T = 2*pi/omega;
    %%% Case if given wave period
        elseif strcmp(param, 'T')
            T = val;
            omega = 2*pi/T;
            k = abs(fzero(@(k) omega^2-g*k*tanh(k*h),0));
            L = 2*pi/k;
        end
    %%% Package up
        W.T = T; 
        W.omega = omega; 
        W.L = L; 
        W.k = k;
        W.kh = k*h;
    end