#!/bin/bash

MY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
MY_DIR="$(dirname $(dirname $MY_PATH))"
REPO_DIR="$(pwd)"

echo "MY DIR: $MY_DIR"
echo "REPO DIR: $REPO_DIR"

###
### PRINTERS
###

if test -t 1; then # if terminal
    ncolors=$(which tput > /dev/null && tput colors) # supports color
    if test -n "$ncolors" && test $ncolors -ge 8; then
        termcols=$(tput cols)
        bold="$(tput bold)"
        underline="$(tput smul)"
        standout="$(tput smso)"
        normal="$(tput sgr0)"
        black="$(tput setaf 0)"
        red="$(tput setaf 1)"
        green="$(tput setaf 2)"
        yellow="$(tput setaf 3)"
        blue="$(tput setaf 4)"
        magenta="$(tput setaf 5)"
        cyan="$(tput setaf 6)"
        white="$(tput setaf 7)"
    fi
fi


print_status() {
    echo
    echo "## $1"
    echo
}

pause_for() {
    print_status "Continuing in $1 seconds ..."
    sleep $1
}

print_bold() {
    local title="$1"
    local text="$2"

    echo
    echo "${red}================================================================================${normal}"
    echo "${red}================================================================================${normal}"
    echo
    echo -e "  ${bold}${yellow}${title}${normal}"
    echo
    echo -en "  ${text}"
    echo
    echo "${red}================================================================================${normal}"
    echo "${red}================================================================================${normal}"
}

print_header() {
    local title="$1"
    local text="$2"

    echo
    echo "${red}================================================================================${normal}"
    echo "${red}================================================================================${normal}"
    echo
    echo -e "  ${bold}${green}${title}${normal}"
    echo
    echo -en "  ${text}"
    echo
    echo "${red}================================================================================${normal}"
    echo "${red}================================================================================${normal}"
}

###
### EXECUTORS
###


bail() {
    echo 'Error executing command, exiting'
    exit 1
}

bail_with_error() {
    print_bold "$1" "$2"
    bail
}

raw_exec_cmd() {
    echo "+ $1"
    bash -c "$1"
}

exec_cmd_no_bail_no_output() {
    local  __resultvar=$2
    local  __returncodevar=$3
    echo "+ $1"
    result=$(bash -c "$1" 2>&1) # dzec
    return_code=$(echo $?)
    eval $__resultvar="'$result'"
    eval $__returncodevar="'$return_code'"
}

exec_cmd_no_bail() {
    exec_cmd_no_bail_no_output "$1" result return_code
    echo "$result"
    local  __resultvar=$2
    local  __returncodevar=$3
    eval $__resultvar="'$result'"
    eval $__returncodevar="'$return_code'"
}

exec_cmd() {
    exec_cmd_no_bail "$1" result return_code
    if [[ $return_code != "0" ]]; then
        bail_with_error "$2" "$result"
    fi
    if [[ ! -z ${3+x} ]]; then 
        local  __resultvar=$3
        eval $__resultvar="'$result'"
    fi
}

exec_cmd_no_output() {
    exec_cmd_no_bail_no_output "$1" result return_code
    if [[ $return_code != "0" ]]; then
        bail_with_error "$2" "$3"
    fi
    if [[ ! -z ${4+x} ]]; then 
        local  __resultvar=$4
        eval $__resultvar="'$result'"
    fi
}


###
### MISC
###
