%{
FW_valid
    - DATE: June 20th
    - Use linear wave theory from the peak period
      and representative water depth to determine
      if FUNWAVE will be stable (probably)

%}
function validity = FW_valid(t,h)
%% Arguments
%{
    - t: (double) period
    - h: (double) description
    - validity: (structure)
        - valid (double): whether or not the run will be valid
            0: is valid
            1: is not valid: kh>pi
            2: is not valid: grid spacing issues
        - W (structure): output structure from linear_dispersion()
        - DX_low (double): lower bound for DX
        - DX_high (double): higher bound for DX
        - SW (double): recommended minimum sponge width
        - WK (double): recommended position for wavemaker
%}
    % Validity parameter: 0 = valid
        valid = 0;
    % Get hydrodynamic variables
        W = linear_dispersion(t,'T',h);
    % Check if kh < pi
        if W.kh > pi
            valid = 1;
        end
    % Check DX
        DX_low = h/15;
        DX_high = W.L/60;
        if DX_high < DX_low
            valid = 2;
        end
    % Sponge Width
        SW = W.L/2;
    % Wavemaker position
        WK = 1.1*W.L;
    
    % Package up:
        validity.valid = valid;
        validity.W = W;
        validity.DX_low = DX_low;
        validity.DX_high = DX_high;
        validity.SW = SW;
        validity.WK = WK;
end