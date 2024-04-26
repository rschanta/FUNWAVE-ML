%% Access helper functions
addpath(genpath('/work/thsu/rschanta/RTS/functions/'));

%% Initialize Structure
ska = struct();

%% Naming
dirs = list_FW_dir('/lustre/scratch/rschanta/','trial_5');

%% Load in each processed output one at a time

for k = 1:900
    eta = load(fullfile(dirs.output_processed,['out_',sprintf('%05d',k),'.mat'])).eta;
    try
    ska.(['out_',sprintf('%05d',k)]) = skew_asym_new(eta,2500);
    disp(['Processed Trial ', num2str(k)])
    clear eta
    catch
        disp(['Could not process Trial ', num2str(k)])
        clear eta
    end
end

save('ska.mat','-struct', 'ska', '-v7.3')
