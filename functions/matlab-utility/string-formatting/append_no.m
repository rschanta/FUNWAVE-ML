%{
append_no
    - appends the trial number in the correct 5 digit format to the 
    specified string and returns a strin
        - EXAMPLE
            append_no('eta_',2) -> 'eta_00002'
%}

function new_string = append_no(var,num)
    new_string = [var,sprintf('%05d',num)];
end
