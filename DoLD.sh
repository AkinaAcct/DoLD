#!/usr/bin/env bash
# By Akina
# WARN: WIP

RED="\033[1;31m"    # RED
YELLOW="\033[1;33m" # YELLOW
BLUE="\033[40;34m"  # BLUE
RESET="\033[0m"     # RESET
DEPENDENCIES="curl jq unzip"
WORKDIR="$(mktemp -d)"
# formatted print
msg_info() {
    printf "${BLUE}[INFO]: ${1}${RESET}\n"
}
msg_warn() {
    printf "${YELLOW}[WARN]: ${1}${RESET}\n"
}
msg_err() {
    printf "${RED}[ERROR]: ${1}${RESET}\n"
}
msg_fatal() {
    printf "${RED}[FATAL]: ${1}${RESET}\n"
}
# Check getopt
if ! (command -v getopt >/dev/null 2>&1); then
    msg_fatal "getopt is NOT installed! Install it first!"
    exit 1
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

-h,                 print this help page and exit.
-l,                 print supported variants and exit.

Required parameters:
-v [INT],           specify the variant to be deployed. Get the variant number from the -l parameter and enter it here.

Optional parameters:
-V [STRING],        specify the variant's version to be deployed.
-p,--prefix,        specify the path where DoL will be installed. Default path is \${HOME}/DOL
"
}

ARGS=$(getopt -o hlp:v:V: --long help,list,prefix,variant:,version: -n "$0" -- "$@")
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
                exit 1
            fi
            case "${2}" in
                1) VARIANT=DOL;;
                2) VARIANT=DOLLYRA;;
                3) VARIANT=DOLPLUS;;
            esac
            v=true
            msg_info "Variant selected: ${VARIANT}"
            shift 2
            ;;
        -V|--version)
            VER="${2}"
            msg_info "Version selected: ${VER}"
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
            echo "wrong"
            exit 1
            ;;
    esac
done
if [[ "${v}" != "true" ]]; then
    msg_fatal "The -v/--variant parameter is required."
    exit 1
fi
if [[ -z ${IPREFIX} ]]; then
    IPREFIX="${HOME}/DOL"
fi
# Check deps 
for i in $DEPENDENCIES; do
    if ! (command -v ${i} >/dev/null 2>&1);then
        msg_fatal "Required dependencies is missing. Missing dependency: ${i}"
    else
        msg_info "${i} is installed."
    fi
done

case ${VARIANT} in
    DOL)
        source DOL/DOL.sh
        ;;
    DOLLYRA)
        source DOLLYRA/DOLLYRA.sh
        ;;
    DOLPLUS)
        msg_err "Developing..."
        exit 1
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
