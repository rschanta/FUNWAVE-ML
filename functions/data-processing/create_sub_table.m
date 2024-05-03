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