#########################################################
# bash_init
#	- load in any of the bash functions needed
#########################################################

	. "${work_dir}functions/bash-utility/slurm-bash.sh"
    . "${work_dir}functions/bash-utility/matlab-bash.sh"
    . "${work_dir}functions/bash-utility/misc-bash.sh"
	. /opt/shared/slurm/templates/libexec/openmpi.sh
