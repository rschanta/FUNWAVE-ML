%outputs = load('outputs.mat');
%% Access helper functions
addpath(genpath('/work/thsu/rschanta/RTS/functions/'));

%% Initialize Structure
ska = struct();
%%
for k = 1:900
    
    eta_i = outputs.(['out_',sprintf('%05d',k)]).eta;
    
    ska.(['out_',sprintf('%05d',k)]) = skew_asym_new(eta_i,200);
    
end

save('ska.mat','-struct', 'ska', '-v7.3')