%{
FW_WK_DATA2D
    - creates a default FWS structure the FW_LEFT_BC_IRR() type 
    of wavemaker, also assuming some input bathymetry
%}
function FWS = FW_WK_DATA2D()
    FWS = struct();
    %%% Title Info
        FWS.TITLE = 'input_DATA.txt';
    %%% Parallel Info
        FWS.PX = int64(16); 
        FWS.PY = int64(2);
    %%% Depth Info
        FWS.DEPTH_TYPE = 'DATA';
        FWS.DEPTH_FLAT = 5; 
        FWS.SLP = 0.1;
        FWS.Xslp = 800; 
    %%% Spectral/Wavemaker Info
        FWS.WAVEMAKER = 'WK_DATA2D';
        FWS.WAVE_DATA_TYPE = 'DATA';
        FWS.WaveCompFile = 'spectra_DATA.txt';
        FWS.PeakPeriod = 2;
        FWS.DEP_WK = 5;

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
    %%% Periodic
        FWS.PERIODIC = 'F';
    %%% Physics
        FWS.Cd = 0;
    %%% Sponge
        FWS.DIFFUSION_SPONGE = 'F'; 
        FWS.FRICTION_SPONGE = 'F'; 
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
		FWS.ROLLER = 'T';
        FWS.UNDERTOW = 'T';
        FWS.ROLLER_EFFECT = 'T';
        FWS.FIELD_IO_TYPE = 'BINARY';
        FWS.RESULT_FOLDER = 'RESULT_FOLDER';
    %%% Associated Files
        files = struct();
        FWS.files= files;
        disp('Created FW_WK_DATA2D template file')