%{
get_D3_coupling
    - prepares a coupling structure to print a FUNWAVE coupling structure,
      with t, u, v, and eta from the Dune3 dataset
%}
function data = get_D3_coupling(df)
%% Arguments
%{
    - df: (struct) structure from a Dune 3 trial containing:
        - raw_data
        - filtered_data
        - wave_condition
%}

%% Get data
    %%% Get start, end time, and time
        t = df.raw_data.t;
        t0 = df.raw_data.t0;
        t_end = df.raw_data.t_end;
    
    %%% Get eta at westernmost gauge
        eta = df.raw_data.eta(:,1);
    
    %%% Get velocities at second ADV 
        u = df.raw_data.u(:,2);
        v = df.raw_data.v(:,2);

%% Package together and create structure
    % Package together into [t u v eta]
        c_data = [t, u, v, eta];
    % Cut using cut function
        c_data = cut(c_data,[t0,t_end],1,4);
    % Package into structure
        data.t = c_data(:,1) - t0;
        data.u = c_data(:,2);
        data.v = c_data(:,3);
        data.eta = c_data(:,4);
end
