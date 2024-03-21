. "/work/thsu/rschanta/RTS/functions/utility/bash-utils.sh"

path="/work/thsu/rschanta/RTS/functions/FW-tools/FW-compress"
func="test"
arg="'Ryan','Schanta',5"

run_MATLAB_function $path $func $arg

#matlab -nodisplay -r "cd('"$path"'); "$func"('"$arg"');exit"

