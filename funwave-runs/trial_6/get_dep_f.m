function calc_skew_asy_f(k)
%% Access helper functions
addpath(genpath('/work/thsu/rschanta/RTS/functions/'));

%% Initialize Structure
dept = struct();

%% Naming
dirs = list_FW_dir('/lustre/scratch/rschanta/','trial_5');

%% Load in each processed output one at a time
dept.dep = load(fullfile(dirs.output_processed,['out_',sprintf('%05d',k),'.mat'])).dep;

name = ['./dep/dep_','out_',sprintf('%05d',k),'.mat'];

save(name,'-struct', 'dept', '-v7.3')
end