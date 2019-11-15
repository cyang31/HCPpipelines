#!/bin/bash

#~ND~FORMAT~MARKDOWN~
#~ND~START~
#
# # Compile_MATLAB_code.sh
#
# Compile the MATLAB code necessary for running the MSMAll Pipeline
#
# ## Copyright Notice
#
# Copyright (C) 2019 The Connectome Coordination Facility (CCF)
#
# * Washington University in St. Louis
# * University of Minnesota
# * Oxford University
#
# ## Author(s)
#
# * Timothy B. Brown, Neuroinformatics Research Group, Washington University in St. Louis
#
# ## Product
#
# [Human Connectome Project][HCP] (HCP) Pipelines
#
# ## License
#
# See the [LICENSE](https://github.com/Washington-University/Pipelines/blob/master/LICENSE.md) file
#
# <!-- References -->
# [HCP]: http://www.humanconnectome.org
#
#~ND~END~

# NOTE: In principle, the use of the @gifti -> gifti-1.6/@gifti symlink should 
# have allowed the use of a single "-I global/matlab", but that doesn't work.
# (Perhaps the compiler doesn't follow symlinks?)
# NOTE: Need to do "-I" on global/matlab/gifti-1.6 BEFORE "-I" on global/matlab 
# otherwise the compile for some reason doesn't find the GIFTI tools.
 
# ------------------------------------------------------------------------------
#  Compile the ComputeVN MATLAB code
# ------------------------------------------------------------------------------

compile_ComputeVN()
{
	local app_name=ComputeVN
	local output_directory=Compiled_${app_name}

	pushd ${HCPPIPEDIR}/MSMAll/scripts > /dev/null
	log_Msg "Working in ${PWD}"

	log_Msg "Creating output directory: ${output_directory}"
	mkdir -p ${output_directory}

	log_Msg "Compiling ${app_name} application"
	${MATLAB_HOME}/bin/mcc -m -v ${app_name}.m \
				  -I ${HCPPIPEDIR}/global/matlab/gifti-1.6 \
				  -I ${HCPPIPEDIR}/global/matlab \
				  -d ${output_directory}

	popd > /dev/null
}

# ------------------------------------------------------------------------------
#  Compile the MSMregression MATLAB code
# ------------------------------------------------------------------------------

compile_MSMregression()
{
	local app_name=MSMregression
	local output_directory=Compiled_${app_name}

	pushd ${HCPPIPEDIR}/MSMAll/scripts > /dev/null
	log_Msg "Working in ${PWD}"

	log_Msg "Creating output directory: ${output_directory}"
	mkdir -p ${output_directory}

	log_Msg "Compiling ${app_name} application"
	${MATLAB_HOME}/bin/mcc -m -v ${app_name}.m \
				  -I ${HCPPIPEDIR}/MSMAll/scripts \
				  -I ${HCPPIPEDIR}/global/matlab/gifti-1.6 \
				  -I ${HCPPIPEDIR}/global/matlab \
				  -d ${output_directory}

	popd > /dev/null
}

# ------------------------------------------------------------------------------
#  Main processing of script.
# ------------------------------------------------------------------------------

main()
{
	compile_ComputeVN
	compile_MSMregression
}

# ------------------------------------------------------------------------------
#  "Global" processing - everything above here should be in a function
# ------------------------------------------------------------------------------

# Verify that HCPPIPEDIR environment variable is set
if [ -z "${HCPPIPEDIR}" ]; then
	script_name=$(basename "${0}")
	echo "${script_name}: ABORTING: HCPPIPEDIR environment variable must be set"
	exit 1
fi

# Load function libraries
source "${HCPPIPEDIR}/global/scripts/debug.shlib" "$@" # Debugging functions; also sources log.shlib

# Verify required environment variables are set and log value
log_Check_Env_Var HCPPIPEDIR
log_Check_Env_Var MATLAB_HOME

# Invoke the main processing
main "$@"
