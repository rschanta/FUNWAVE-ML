function bathy_clean = unique_bathy(bathy)
    % Check if the input array has two columns
    if size(bathy, 2) ~= 2
        error('Input array must have exactly two columns.');
    end
    
    % Find unique values in column 1
    uniqueValues = unique(bathy(:, 1));
    
    % Initialize the cleaned array
    bathy_clean = [];
    
    % Iterate through unique values and add the first occurrence to cleaned array
    for i = 1:length(uniqueValues)
        idx = find(bathy(:, 1) == uniqueValues(i), 1, 'first');
        rowToAdd = bathy(idx, :);
        % Add the first occurrence of each unique value to the cleaned array
        bathy_clean = [bathy_clean; rowToAdd];
    end
end