# FWS_in_SLP

This template initializes a FUNWAVE run for a 1 dimensional beach with a constant slope and a 
flat portion outside, with a wavemaker and a sponge layer. The corresponding **FWS** structure looks like:

```
 FWS = struct();
    %%% Title Info
        FWS.TITLE = 'input_SLP.txt';
    %%% Parallel Info
        FWS.PX = int64(16); 
        FWS.PY = int64(2);
    %%% Depth Info
        FWS.DEPTH_TYPE = 'SLOPE';
        FWS.DEPTH_FLAT = 5; 
        FWS.SLP = 0.1;
        FWS.Xslp = 800; 
    %%% Dimensions
        FWS.Mglob = int64(1024); 
        FWS.Nglob = int64(3);
    %%% Time  
        FWS.TOTAL_TIME = 100; 
        FWS.PLOT_INTV = 1; 
        FWS.PLOT_INTV_STATION = 0.5; 
        FWS.SCREEN_INTV = 1;
    %%% Grid Size
        FWS.DX = 1; 
        FWS.DY = 1;
    %%% Wavemaker
        FWS.WAVEMAKER = 'WK_REG'; 
        FWS.DEP_WK = 5; 
        FWS.Xc_WK = 250; 
        FWS.AMP_WK = 1; 
        FWS.Tperiod = 1; 
        FWS.Theta_WK = 0; 
        FWS.Delta_WK = 3;
    %%% Periodic
        FWS.PERIODIC = 'F';
    %%% Physics
        FWS.Cd = 0;
    %%% Sponge
        FWS.DIFFUSION_SPONGE = 'F'; 
        FWS.FRICTION_SPONGE = 'T'; 
        FWS.DIRECT_SPONGE = 'T'; 
        FWS.Csp = '0.0'; 
        FWS.CDsponge = 1.0; 
        FWS.Sponge_west_width = 0; 
        FWS.Sponge_east_width = 0; 
        FWS.Sponge_south_width = 0; 
        FWS.Sponge_north_width = 0;
    %%% Numerics
        FWS.CFL = 0.4; 
        FWS.FroudeCap = 3;
    %%% Wet-Dry
        FWS.MinDepth = 0.01;
    %%% Breaking
        FWS.VISCOSITY_BREAKING = 'T'; 
        FWS.Cbrk1 = 0.65; 
        FWS.Cbrk2 = 0.35;
    %%% Wave-Averaging
        FWS.T_INTV_mean = 3; 
        FWS.STEADY_TIME = 3;
    %%% Output
        FWS.DEPTH_OUT = 'T'; 
        FWS.WaveHeight = 'T'; 
        FWS.ETA = 'T'; 
        FWS.MASK = 'T'; 
        FWS.U = 'T'; 
        FWS.V = 'T'; 
        FWS.FIELD_IO_TYPE = 'BINARY';
        FWS.RESULT_FOLDER = 'RESULT_FOLDER';
    %%% Associated Files
        files = struct();
        FWS.Files= files;
```

which creates an input file that looks like:

> TITLE = input_SLP
> 
> PX = 16
> 
> PY = 2
> 
> DEPTH_TYPE = SLOPE
> 
> DEPTH_FLAT = 5
> 
> SLP = 0.05
> 
> Xslp = 800
> 
> Mglob = 1024
> 
> Nglob = 3
> 
> TOTAL_TIME = 400.0
> 
> PLOT_INTV = 1.0
> 
> PLOT_INTV_STATION = 0.5
> 
> SCREEN_INTV = 1.0
> 
> DX = 2
> 
> DY = 2
> 
> WAVEMAKER = WK_REG
> 
> DEP_WK = 5
> 
> Xc_WK = 250
> 
> AMP_WK = 1
> 
> Tperiod = 1
> 
> Theta_WK = 0.0
> 
> Delta_WK = 3.0
> 
> PERIODIC = F
> 
> Cd = 0.0
> 
> DIFFUSION_SPONGE = F
> 
> FRICTION_SPONGE = T
> 
> DIRECT_SPONGE = T
> 
> Csp = 0.0
> 
> CDsponge = 1.0
> 
> Sponge_west_width = 0
> 
> Sponge_east_width = 0.0
> 
> Sponge_south_width = 0.0
> 
> Sponge_north_width = 0.0
> 
> CFL = 0.35
> 
> FroudeCap = 3.0
> 
> MinDepth = 0.01
> 
> VISCOSITY_BREAKING = T
> 
> Cbrk1 = 0.65
> 
> Cbrk2 = 0.35
> 
> T_INTV_mean = 3.0
> 
> STEADY_TIME = 3.0
> 
> DEPTH_OUT = T
> 
> WaveHeight = T
> 
> ETA = T
> 
> MASK = T
> 
> U = T
> 
> V = T
> 
> FIELD_IO_TYPE = BINARY
> 
> RESULT_FOLDER = RESULT_FOLDER

