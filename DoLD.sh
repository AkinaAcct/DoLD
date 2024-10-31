#!/usr/bin/env bash
# By Akina
# WARN: WIP

if [[ "${DOLDDEBUG}" == "true" ]]; then
    set -x
    printf "\033[1;33m%s\033[0m" "[WARN]: ENV DOLDDEBUG=true. DEBUG mode is on."
fi

RED="\033[1;31m"    # RED
YELLOW="\033[1;33m" # YELLOW
BLUE="\033[40;34m"  # BLUE
RESET="\033[0m"     # RESET
DEPENDENCIES="curl jq unzip"
WORKDIR="$(mktemp -d)"
# formatted print
msg_info() {
    printf "${BLUE}%s${RESET}\n" "[INFO]: ${1}"
}
msg_warn() {
    printf "${YELLOW}%s${RESET}\n" "[WARN]: ${1}"
}
msg_err() {
    printf "${RED}%s${RESET}\n" "[ERROR]: ${1}"
}
msg_fatal() {
    printf "${RED}%s${RESET}\n" "[FATAL]: ${1}"
    exit 1
}
msg_cus(){
    printf "${!1}%s${RESET}\n" "[${2}]: ${3}"
}
# Check getopt
if ! (command -v getopt >/dev/null 2>&1); then
    msg_fatal "getopt is NOT installed! Install it first!"
fi
if [[ "$(getopt -T >/dev/null 2>&1;echo ${?})" -ne 4 ]];then
    msg_warn "Not enhanced getopt. Some operations may result in errors."
fi

VARIANTS=([1]DoL [2]DoL-Lyra [3]DoLPlus) # Supported variants
print_variants(){
    msg_info "Supported variants:"
    for i in "${VARIANTS[@]}"; do
        printf "${BLUE}%s ${RESET}" "$i"
    done
}
print_help(){
    printf "${BLUE}%s${RESET}\n" "
DoL Local - Ver. 0.0.1

-h, --help,                                  print this help page and exit.
-l, --list,                                  print supported variants and exit.

Required parameters:
-v [VARIANT], --variant [VARIANT],           specify the variant to be deployed. Get the variant number from the -l parameter and enter it here.

Optional parameters:
-V [STRING], --version [STRING],             specify the variant's version to be deployed.
-p PATH/TO/FOLDER,--prefix PATH/TO/FOLDER,   specify the path where DoL will be installed. Default path is \${HOME}/DOL
"
}

ARGS=$(getopt -o hlp:v:V: --long help,list,prefix:,variant:,version: -n "$0" -- "$@")
if [[ ${#} -eq 0 ]]; then
    print_help
    exit 0
fi
eval set -- "$ARGS"
while true; do
    case "$1" in
        -h|--help)
            print_help
            shift
            exit 0
            ;;
        -l|--list)
            print_variants
            shift
            exit 0
            ;;
        -v|--variant)
            if [[ ! "${2}" =~ ^[1-3]$ ]]; then
                msg_fatal "Incorrect input: ${2}"
            fi
            case "${2}" in
                1) VARIANT=DOL;;
                2) VARIANT=DOLLYRA;;
                3) VARIANT=DOLPLUS;;
            esac
            v=true
            msg_info "Variant selected: ${2}, ${VARIANT}"
            shift 2
            ;;
        -V|--version)
            VER="${2}"
            msg_info "Version selected: ${VER}"
            msg_err "Unfinished feature: version selection."
            exit 1
            shift 2
            ;;
        -p|--prefix)
            IPREFIX="${2}"
            msg_info "Prefix specified. IPREFIX: ${IPREFIX}"
            shift 2
            ;;
        --)
            EXTRAARG="${2}"
            break
            ;;
        *)
            msg_fatal "Unexpected behaviour."
            ;;
    esac
done
if [[ "${v}" != "true" ]]; then
    msg_fatal "The -v/--variant parameter is required."
fi
if [[ -z ${IPREFIX} ]]; then
    IPREFIX="${HOME}/DOL"
fi
# Check deps 
for i in ${DEPENDENCIES}; do
    if ! (command -v ${i} >/dev/null 2>&1);then
        MISSING+=("${i}")
        msg_cus RED DEPS "Required dependencies is missing. Missing dependency: ${i}"
    else
        msg_cus BLUE DEPS "${i} is installed."
    fi
done
if [[ -n ${MISSING[*]} ]]; then
    msg_fatal "Missing ${#MISSING[*]} dependency(ies). Install ${MISSING[*]} first."
fi

case ${VARIANT} in
    DOL)
        mkdir -p "${IPREFIX}/DoL"
        source DOL/DOL.sh
        ;;
    DOLLYRA)
        mkdir -p "${IPREFIX}/DoL-Lyra"
        source DOLLYRA/DOLLYRA.sh
        ;;
    DOLPLUS)
        mkdir -p "${IPREFIX}/DoL-Plus"
        source DOLPLUS/DOLPLUS.sh
        ;;
esac
msg_info "Now cleaning tmp files..."
rm -rf "${WORKDIR}"
msg_info "Done."
#if [[ "${v}" != "true"  ]] || [[ "${V}" != "true" ]]; then
#    msg_fatal "-v/--variant and -V/--version must be used simultaneously!"
#fi
#DoLOri() {}
#DoLLyra() {}
#DoLPlus() {}
#DoLCNLocale() {}
