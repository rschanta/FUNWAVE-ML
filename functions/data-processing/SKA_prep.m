addpath(genpath('/work/thsu/rschanta/RTS/functions/'))
super_path = '/lustre/scratch/rschanta/';
run_name = 'trial_11';
ML_vals = SKA_prep2(super_path,run_name)
parquetwrite('ML_vals.parquet',ML_vals)
function ML_vals = SKA_prep2(super_path,run_name)


    % Get paths
        paths = list_FW_dirs(super_path,run_name);
        skew_path = fullfile(paths.run_name,'skew.mat');
        asy_path = fullfile(paths.run_name,'asy.mat');
        out_proc = paths.outputs_proc;
    % Load in inputs, skew, and asymmetry
        inputs = load(paths.inputs_s);
        inputs_t = readtable(paths.inputs_t);
        skew = load(skew_path);
        asy = load(asy_path);

    %% Create ML table/parquet
    % Names of trials
        titleArray = fieldnames(inputs);
    % Table for results
        ML_vals = table();
    for k = 1:length(titleArray)
        % Get name of trial
            tri_name_in = titleArray{k};
            tri_name_out = ['out_',tri_name_in(end-4:end)];
        % Get dep, DEP_FLAT, skew, and asy for just trial
            output_proc = load(fullfile(out_proc,[tri_name_out,'.mat']));
            params.dep = output_proc.dep;
            params.skew = skew.(tri_name_out);
            params.asy = asy.(tri_name_out);
            DEPTH_FLAT = inputs.(tri_name_in).DEPTH_FLAT;
        % Cut out beach portion
            [cut_params, beach_start_i] = cut_out_beach(params,DEPTH_FLAT);
        % Create sub table
            sub_table = create_sub_table(inputs_t,cut_params,tri_name_in);
        % Append to larger table;
            ML_vals = [ML_vals; sub_table];
    end
end



