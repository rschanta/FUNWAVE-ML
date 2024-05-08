%{
compress_out_ska_i
    - same as compress_out_i, but calculates skew and asymmetry right away
%}
function results = compress_out_ska_i(super_path,run_name,tri_no)
%% Arguments
%{
    - super_path: super_path for run
    - run_name: run_name of run
    - tri_no: trial number as an integer/double
%}

%% Get all important paths
    paths = list_FW_dirs(super_path,run_name);
%% Trial number string
    tri_no_str = sprintf('%05d',tri_no);
%% Construct directory to output
    res_path = [paths.out_raw_i,tri_no_str];

%% Load in input structure corresponding to trial in res_path
    input_tr = ['input_',tri_no_str];
    FW_in = load(paths.inputs_s,input_tr);
    FW_in = FW_in.(input_tr);

%% Get Mglob and Nglob
    Mglob = double(FW_in.Mglob);
    Nglob = double(FW_in.Nglob);
 
%% Initialize output structure
    results = struct();

%% Get variables of interest
    results.in = FW_in;
    results.dep = compress_var(res_path,'dep',Mglob,Nglob);
    results.eta = compress_var(res_path,'eta_',Mglob,Nglob);
    results.u = compress_var(res_path,'u_',Mglob,Nglob);
    results.v = compress_var(res_path,'v_',Mglob,Nglob);
%% Calculate skew and asymmetry right away
    ska = array_ska(results.eta,1);
    results.skew = ska.skew;
    results.asy = ska.asy;
%% Save out
    name = fullfile(paths.outputs_proc,['out_',tri_no_str,'.mat']);
    save(name,'-struct', 'results', '-v7.3')
end