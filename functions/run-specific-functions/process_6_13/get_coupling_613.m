function data = get_coupling_613(df,gage)
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
    eta = df.filtered_data.eta(:,gage);
%% Get velocities at second ADV
    if gage == 1
        u = zeros(length(eta),1);
        v = zeros(length(eta),1);
    end
    if gage == 2
        u = df.raw_data.u(:,1);
        v = df.raw_data.v(:,1);
    end

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
