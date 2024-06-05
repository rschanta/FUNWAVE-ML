%{
tri_num
    - constructs a string 'tri_XXXXX' in correct 5 digit format
      as a string
%}

function num_str = tri_no(num)
    num_str = ['tri_',sprintf('%05d',num)];
end