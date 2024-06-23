%{
cut
    - "cuts" out columns of a matrix corresponding to some range of values
      in the column specified by "col". Most commonly, this will be time or
      x position. It cuts between the "bounds" which is 2D array, and the
      number of columns in the matrix must be explicitly specified.

    - Example:
        X = [1.0 2.0 2.2;
             1.5 2.3 8.9; 
             2.0 2.6 3.6; 
             2.5 6.2 8.0; 
             3.0 8.3 1.5] 

        -times = [1.5 2.5]

        `cut(X,times,1,3)` outputs the following:

         cut_out = [1.5 2.3 8.9;  
                    2.0 2.6 3.6; 
                    2.5 6.2 8.0];       
%}
function cutout = cut(array,bounds,col,no_cols)
%% Arguments
%{
    - array (2D array): array to cut
    - bounds (array of 2 numbers): bounds to cut between
    - col (integer): index of the column to use as the index variable
    - no_cols (int): number of columns in the array
%}
    % Make sure array is no_cols
        array = reshape(array, [], no_cols);
    % Find beginning and ending indices
        [~, beg_i] = min(abs(array(:,col) - bounds(1)));
        [~, end_i] = min(abs(array(:,col) - bounds(2)));
    % Index out
    cutout = array(beg_i:end_i,:);
end