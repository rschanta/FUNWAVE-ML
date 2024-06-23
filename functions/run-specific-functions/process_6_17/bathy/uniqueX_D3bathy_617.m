%{
make_unique_X
    - Cuts two arrays that are paired together X and Y respectively such
      that any points duplicated in X are removed after the first instance
    - Example:
        X = [1 2 3 4 4 5]
        Y = [4 2 3 9 1 4]

        X_out = [1 2 3 4 5]
        Y_out = [4 2 3 9 4]
%}

function [X_out,Y_out] = uniqueX_D3bathy_617(X,Y)
%% Arguments
%{
    - X (1D array)
    - Y (1D array) must have same dimension as X
%}

 
%%% Find unique values in X array
uniqueValues = unique(X);

%%% Initialize the cleaned array
unique_array = [];

% Iterate through unique values and add the first occurrence to cleaned array
for i = 1:length(uniqueValues)
    idx = find(X == uniqueValues(i), 1, 'first');
    rowToAdd = [X(idx), Y(idx)];
    % Add the first occurrence of each unique value to the cleaned array
    unique_array = [unique_array; rowToAdd];
end

%%% Separate outputs
    X_out = unique_array(:,1);
    Y_out = unique_array(:,2);
end