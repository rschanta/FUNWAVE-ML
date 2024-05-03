clear 
%%% Load in inputs and outputs
    skew = load("/lustre/scratch/rschanta/trial_11/skew.mat");
    asy = load("/lustre/scratch/rschanta/trial_11/asy.mat");
    inputs = readtable("/lustre/scratch/rschanta/trial_11/inputs-t.txt");
    %%
    inputs_s = load("/lustre/scratch/rschanta/trial_11/inputs-s.mat");
    %%
    outputs = load("/lustre/scratch/rschanta/trial_11/outputs.mat");
%%
% %%% Initialize tables
%     skew_table = zeros(length(fieldnames(skew)),length(skew.out_00001));
%     asy_table = zeros(length(fieldnames(skew)),length(asy.out_00001));
%     dep_table = zeros(length(fieldnames(skew)),length(outputs.out_00001.dep));
% %%% Combine together
%     for k = 1:length(fieldnames(skew))
%         skew_table(k,:) = skew.(['out_', sprintf('%05d',k)]);
%         asy_table(k,:) = asy.(['out_', sprintf('%05d',k)]);
%         dep_table(k,:) = outputs.(['out_', sprintf('%05d',k)]).dep;
%     end
%     
% skew_table = convert2table(skew_table,'s');
% asy_table = convert2table(asy_table,'a');
% dep_table = convert2table(dep_table,'d');
% total_tab = [inputs dep_table skew_table asy_table];

%% Prepare input table
% % List of variables to remove
% varsToRemove = {'PX', 'PY','TOTAL_TIME','PLOT_INTV_STATION','SCREEN_INTV'...
%     ,'PERIODIC', 'DEPTH_OUT', 'WaveHeight','ETA','MASK','U','V',...
%     'FIELD_IO_TYPE','RESULT_FOLDER'};
% inputs = removevars(inputs, varsToRemove);


%% Create ML table/parquet
    % Names of trials
        titleArray = fieldnames(inputs_s);
        %%
    % Table for results
        ML_vals = table();
    for k = 1:length(titleArray)
        % Get name of trial
            tri_name_in = titleArray{k};
            tri_name_out = ['out_',tri_name_in(end-4:end)];
        % Get dep, DEP_FLAT, skew, and asy for just trial
            params.dep = outputs.(tri_name_out).dep;
            params.skew = skew.(tri_name_out);
            params.asy = asy.(tri_name_out);
            DEPTH_FLAT = inputs_s.(tri_name_in).DEPTH_FLAT;
        % Cut out beach portion
            [cut_params, beach_start_i] = cut_out_beach(params,DEPTH_FLAT);
        % Create sub table
            sub_table = create_sub_table(inputs,cut_params,tri_name_in);
        % Append to larger table;
            ML_vals = [ML_vals; sub_table];
    end
    
%%

%% Create sub table
function sub_table = create_sub_table(inputs,cut_params,tri_name)
    % Row to repeat
        row = inputs(strcmp(inputs.TITLE, tri_name), :);
    % Add column for double trial number
        row.tri = str2double(extractAfter(row.TITLE, 'input_'));
        row = movevars(row, 'tri', 'Before', 1);
    % Number of times to repeat row
        n = length(cut_params.dep);
    % Create repeated table
        sub_table = repmat(row, n, 1);
    % Add on Dep, skew, and asymetry columns
        sub_table.dep = cut_params.dep(:);
        sub_table.skew = cut_params.skew(:);
        sub_table.asy = cut_params.asy(:);
end


%%% Convert each to table and name appropriately
function data_table = convert2table(array,name)
    data_table = array2table(array);

    % Name the columns dynamically
    num_columns = width(data_table);
    column_names = cell(1, num_columns);
    for i = 1:num_columns
        column_names{i} = [name num2str(i)];
    end
    data_table.Properties.VariableNames = column_names;

end


