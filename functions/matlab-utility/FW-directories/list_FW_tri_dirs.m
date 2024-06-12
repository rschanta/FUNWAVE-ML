%{
list_FW__tri_dirs
    - returns a structure with all the paths associated with a FUNWAVE 
      trial within a run, (input_XXXXX.txt, out_XXXXX/RESULT_FOLDER) and 
      name of the input file (`input_XXXXX`)
%}
function ptr = list_FW_tri_dirs(tri_num,p)
    %% Arguments
    %{
        - tri_num: (double/int) trial number
        - p: (structure) `p` structure output from `list_FW_dirs` 
    %}
    %% Input naming
        % Trial number
            ptr.num_str = tri_no(tri_num);
        % Input Name/Title
            ptr.input_name = append_no('input_',tri_num);
        % Path to the input_XXXXX.txt file
            ptr.i_file = [append_no(p.i_,tri_num),'.txt'];
        % Path to out_XXXXX folder (RESULT_FOLDER) to put into FUNWAVE 
            ptr.RESULT_FOLDER = [append_no(p.o_,tri_num),'/'];
        % Path to bathy_XXXXX.txt file
            ptr.b_file = [append_no(p.b_,tri_num),'.txt'];
        % Path to coupling_XXXXX.txt file
            ptr.c_file = [append_no(p.c_,tri_num),'.txt'];
        % Path to spectra_XXXXX.txt file
            ptr.sp_file = [append_no(p.sp_,tri_num),'.txt'];
        % Path to dep.out
            ptr.dep_file = fullfile(ptr.RESULT_FOLDER,'dep.out');
        % Path to time_dt.out
            ptr.time_dt_file = fullfile(ptr.RESULT_FOLDER,'time_dt.out');

end
