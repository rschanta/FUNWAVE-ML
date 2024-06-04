%{
calc_stats
    - Loop through the cell array of function names
    defined by f_list to apply all the functions to the 
    structure st
%}

function calc_stats(st,f_list,no,sp,rn)
    % Loop through functions of flist and apply to structure
    %try
        if length(f_list)>0
            for f = f_list
                disp(['Applying function: ', f])
                fun = str2func(f{1});
                fun(st,no,sp,rn);
            end
        else
            disp("No statistics functions defined")
        end
    %catch
    %    disp("Issue with statistics calculation!")
    %end
end