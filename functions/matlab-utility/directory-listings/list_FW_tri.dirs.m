%{
list_FW_dirs
    - returns a structure with all the paths associated with a FUNWAVE 
      trial within a run, (input_XXXXX.txt, out_XXXXX/RESULT_FOLDER) and 
      name of the input file (`input_XXXXX`)
%}
function tpaths = list_FW_tri_dirs(tri,paths)
%% Argument
%{
    - tri: (double/int) trial number
    - paths: (structure) `paths` structure output from `list_FW_dirs` or 
        `mk_FW_dirs`
%}
%% Input naming
    % Number as a 5-digit string
        tpaths.no = sprintf('%05d',tri);
    % Name to put into FUNWAVE input.txt file
        tpaths.input_name= ['input_',tpaths.no];
    % Path to the input_XXXXX.txt file
        tpaths.input = fullfile(paths.inputs,['input_',tpaths.no,'.txt']);
    % Path to out_XXXXX folder (RESULT_FOLDER) to put into FUNWAVE 
    % input.txt file
        tpaths.RESULT_FOLDER = fullfile(paths.output_raw,['out_',tpaths.no,'/']);
end
