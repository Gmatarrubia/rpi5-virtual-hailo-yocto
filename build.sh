#!/bin/bash

repoPath="$(dirname $(realpath ${BASH_SOURCE[0]}))"
targetsPath="$repoPath/targets"
kasFeaturesPath="${targetsPath}/features"
__debug_conf_file="${kasFeaturesPath}/debug.yml"

# Script arguments handle
__bitbake_cmd=()
__only_shell=
__debug=
__parallel_limit=
__cores=
__conf_name=
__update_lock=
__extra_conf_files=
__log_level="info"

while (( $# )); do
    case ${1,,} in
        -b|--bitbake)
            shift
            __bitbake_cmd+=("${@}")
            echo Custom bitbake command: "${__bitbake_cmd[@]}"
            ;;
        --shell)
            __only_shell=1
            echo "Only shell mode"
            ;;
        -m|--machine)
            __conf_name="$2"
            shift
            ;;
        --debug)
            __extra_conf_files="${__extra_conf_files}:${__debug_conf_file}"
            ;;
        --update)
            __update_lock=1
    esac
    shift
done

# Check machine target argument
if [ -z "${__conf_name}" ]
then
    echo "-m|--machine argument mandatory. Please specify a machine name."
    echo "exit."
    exit 2
fi

# Start configuration
export CONF_FILE="${targetsPath}/${__conf_name}.yml"
export KAS_BUILD_DIR="${repoPath}/build_${__conf_name}"
export DL_DIR="${repoPath}/dl"
export SSTATE_DIR="${repoPath}/sstate"
export SHELL="/bin/bash"
rm -rf "${KAS_BUILD_DIR}"/conf/*

# Check if config file exists
if [ ! -f "${CONF_FILE}" ]
then
    echo "Machine ${__conf_name} unknown"
    echo "Config file doesn't exist: ${CONF_FILE}"
    exit 2
fi

# Check if sources were downloaded
if [ ! -d "${repoPath}/sources" ]
then
    kas checkout "${CONF_FILE}"
fi

# Update lock environment in shell mode
if [ -n "${__update_lock}" ]
then
    kas -l "${__log_level}" lock "${CONF_FILE}"
    exit 0
fi

# Start environment in shell mode
if [ -n "${__only_shell}" ]
then
    kas -l "${__log_level}" shell -E "${CONF_FILE}${__extra_conf_files}"
    exit 0
fi

if [ -z "${__bitbake_cmd[*]}" ]
then
    time kas -l "${__log_level}" build "${CONF_FILE}${__extra_conf_files}"
else
    echo "Executing command: ${__bitbake_cmd[*]}"
    time kas -l "${__log_level}" shell "${CONF_FILE}${__extra_conf_files}" -c "${__bitbake_cmd[*]}"
fi
