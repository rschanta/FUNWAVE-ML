%% Access helper functions
addpath(genpath('/work/thsu/rschanta/RTS/functions/'));

%% Initialize Structure
dep = struct();
%%
for k = 1:900
    disp(k)
    dep_i = load(['./dep/dep_out_',sprintf('%05d',k)]);
    
    dep.(['out_',sprintf('%05d',k)]) = dep_i;
    
end

save('dep.mat','-struct', 'dep', '-v7.3')