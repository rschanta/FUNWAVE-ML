%{
compress_out_i
    - compresses all the outputs from a given FUNWAVE run from the series
      of time-stepping files to a single structure with fields for all the
      variables of interest (eta, u, v, etc.
%}
function results = compress_out_i(super_path,run_name,tri_no)
%% Arguments
%{
    - super_path: super_path for run
    - run_name: run_name of run
    - tri_no: trial number as an integer/double
%}

%% Load in helper functions
    addpath(genpath('/work/thsu/rschanta/RTS/functions/'));
%% Get all important paths
    paths = list_FW_dir(super_path,run_name);
%% Trial number string
    tri_no_str = sprintf('%05d',tri_no);
%% Construct directory to output
    res_path = [paths.out_raw_i,tri_no_str];

%% Load in input structure corresponding to trial in res_path
    input_tr = ['input_',tri_no_str];
    FW_in = load(paths.input_sum_path,input_tr);
    FW_in = FW_in.(input_tr);

%% Get Mglob and Nglob
    Mglob = double(FW_in.Mglob);
    Nglob = double(FW_in.Nglob);
 
%% Initialize output structure
    results = struct();

%% Get variables of interest
    results.dep = compress_var(res_path,'dep',Mglob,Nglob);
    results.eta = compress_var(res_path,'eta_',Mglob,Nglob);
    results.u = compress_var(res_path,'u_',Mglob,Nglob);
    results.v = compress_var(res_path,'v_',Mglob,Nglob);

    name = fullfile(paths.output_processed,['out_',tri_no_str,'.mat']);
    save(name,'-struct', 'results', '-v7.3')
end