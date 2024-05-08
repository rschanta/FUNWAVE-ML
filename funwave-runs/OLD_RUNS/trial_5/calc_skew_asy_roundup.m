%% Access helper functions
addpath(genpath('/work/thsu/rschanta/RTS/functions/'));

%% Initialize Structure
ska = struct();
%%
for k = 1:900
    disp(k)
    ska_i = load(['./ska/ska_out_',sprintf('%05d',k)]);
    
    ska.(['out_',sprintf('%05d',k)]) = ska_i;
    
end

save('ska.mat','-struct', 'ska', '-v7.3')