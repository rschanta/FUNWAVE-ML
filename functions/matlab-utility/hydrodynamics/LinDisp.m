%{
LinDisp
    - returns a structure with all the paths associated with a FUNWAVE 
      trial within a run, (input_XXXXX.txt, out_XXXXX/RESULT_FOLDER) and 
      name of the input file (`input_XXXXX`)
%}


function W = LinDisp(val,param,h)
%% Arguments
%{
    - val: (double/int) trial number
    - param: (structure) `paths` structure output from `list_FW_dirs` or 
        `mk_FW_dirs`
%}

%%% Gravitational Constant and water height
    g = 9.81; % gravity
    W.h = h;

%%% Case if given wavenumber k
    if strcmp(param, 'k')
        W.k = val;
        W.omega = sqrt(g*W.k*tanh(W.k*W.h));
        W.T = 2*pi/W.omega;
        W.lambda = 2*pi/W.k;
%%% Case if given angular frequency omega
    elseif strcmp(param, 'omega')
        W.omega = val;
        W.T = 2*pi/W.omega;
        W.k = abs(fzero(@(k) W.omega^2-g*k*tanh(k*W.h),0));
        W.L = 2*pi/W.k;
%%% Case if given wavelength
    elseif strcmp(param, 'lambda')
        W.lambda = val;
        W.k = 2*pi/W.lambda;
        W.omega = sqrt(g*W.k*tanh(W.k*W.h));
        W.T = 2*pi/W.omega;
%%% Case if given wave period
    elseif strcmp(param, 'T')
        W.T = val;
        W.omega = 2*pi/W.T;
        W.k = abs(fzero(@(k) W.omega^2-g*k*tanh(k*W.h),0));
        W.L = 2*pi/W.k;
    end
end