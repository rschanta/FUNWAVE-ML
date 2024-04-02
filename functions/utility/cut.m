%{
  Function to cutout elements of an array  
%}
function cutout = cut(array,bounds,col,no_cols)
    % Make sure array is no_cols
        array = reshape(array, [], no_cols);
    % Find beginning and ending indices
        [~, beg_i] = min(abs(array(:,col) - bounds(1)));
        [~, end_i] = min(abs(array(:,col) - bounds(2)));
    % Index out
    cutout = array(beg_i:end_i,:);