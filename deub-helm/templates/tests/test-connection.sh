#!/bin/bash
#

usage(){
    cat << EOF
A script that checks the response of the nginx in localhost, port 8080 (configurable)
Usage: $0 [--url URL] [--user USER] [--pass PASSWD] [--response INT] [--repeat INT]
    -u | --url <URL> - the URL to test connection for - default: http://localhost:8080
    --user <STRING> - In case the HTTP requires authentication, this is the user
    --pass <STRING> - In case the HTTP requires authentication, this is the password
    --response <INT> - the HTTP code of the connection - default: 200
    -s | --repeat - if the script should automatically repeat itself every <INT> seconds
                    default is --repeat 0 , which means no repeat; runs one off
EOF
}

# default values
URL="http://localhost:8080"
REPEAT_EVERY=0
RESPONSE=200
ERR=false

# digest parameters
PARAM_SET=$(getopt -o hu:s: --long help,url:,user:,pass:,repeat:,response: -- "$@")
if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi
eval set -- "${PARAM_SET}"
while [[ $# -gt 0 ]]; do
    case "${1}" in
        -h | --help ) usage; exit 0;;
        -u | --url ) 
                URL="${2}"; shift 2 ;;
        --user ) USER="${2}"; shift 2 ;;
        --pass ) PASS="${2}"; shift 2 ;;
        -s | --repeat ) REPEAT_EVERY=${2}; shift 2 ;;
        --response ) RESPONSE=${2}; shift 2 ;;
        -- ) break;;
        * )  usage; exit 0;;
    esac      
done

# the work
while true; do
    if [[ -n "${USER}" ]]; then
        OUT=$(curl -o /dev/null -s -w "%{http_code}\n" --user ${USER}:${PASS} "${URL}") || ERR=true
    else
        OUT=$(curl -o /dev/null -s -w "%{http_code}\n" "${URL}") || ERR=true
    fi
    #
    if ${ERR}; then 
        echo "There is a problem in accessing ${URL}. Run the curl command manually."
    elif [[ $OUT != $RESPONSE ]]; then
        echo "Unhealthy response: '${RESPONSE}'" && [[ ${REPEAT_EVERY} -eq 0 ]] && exit 9
    fi
    [[ ${REPEAT_EVERY} -eq 0 ]] && break
    sleep ${REPEAT_EVERY}
done