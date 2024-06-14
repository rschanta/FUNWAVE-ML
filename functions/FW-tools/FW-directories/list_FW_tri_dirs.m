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
        % Run Name
            ptr.RN = p.RN_str;
        % Input Name/Title
            ptr.input_name = append_no('input_',tri_num);
        % Path to the input_XXXXX.txt file
            ptr.i_file = [append_no(p.i_,tri_num),'.txt'];
        % Path to out_XXXXX folder (RESULT_FOLDER) to put into FUNWAVE 
            ptr.RESULT_FOLDER = [append_no(p.o_,tri_num),'/'];
            %make_dir(ptr.RESULT_FOLDER); 
        % Path to bathy_XXXXX.txt file
            ptr.b_file = [append_no(p.b_,tri_num),'.txt'];
        % Path to coupling_XXXXX.txt file
            ptr.c_file = [append_no(p.c_,tri_num),'.txt'];
        % Path to spectra_XXXXX.txt file
            ptr.sp_file = [append_no(p.sp_,tri_num),'.txt'];
        % Path to condensed output structure
            ptr.out_file = [append_no(p.O_,tri_num),'.mat'];
        % Path to dep.out
            ptr.dep_file = fullfile(ptr.RESULT_FOLDER,'dep.out');
        % Path to time_dt.out and create it
            ptr.time_dt_file = fullfile(ptr.RESULT_FOLDER,'time_dt.txt');
            %fid = fopen(ptr.time_dt_file, 'w');
            %fclose(fid);
        % Path to bathymetry figure
            ptr.b_fig = [append_no(p.bF_,tri_num),'.png'];
        % Path to spectra figure
            ptr.sp_fig = [append_no(p.spF_,tri_num),'.png'];
        % path to eta animation
            ptr.aniE = [append_no(p.aniE_,tri_num),'.avi'];
        % path to u animation
            ptr.aniU = [append_no(p.aniU_,tri_num),'.avi'];
        % path to Undertow U
            ptr.aniUU = [append_no(p.aniUU_,tri_num),'.avi'];
        % path to Undertow U
            ptr.aniVU = [append_no(p.aniVU_,tri_num),'.avi'];


end
