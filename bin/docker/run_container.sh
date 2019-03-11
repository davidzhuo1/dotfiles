#!/bin/bash -e

print_usage() {
    echo "Usage: run_container.sh [options]"
    echo " -p         Privileged mode (dmesg, other 'risky' functions)"
    echo " -a         Attached mode (run in foreground)"
    exit 0
}

IMG_NAME="dz_dev"

PRIVILEGED=""
ATTACHED="-d"
while getopts "pa" opt; do
  case ${opt} in
    p )
        PRIVILEGED="--privileged"
        ;;
    i )
        ATTACHED=""
        ;;
    h )
        print_usage
        ;;
  esac
done
shift $((OPTIND -1))

# Kill all currently running instances. One only at a time
DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd)"
${DIR}/stop_container.sh
sleep 1

DOCKER_COMMAND="docker run --rm -it ${ATTACHED} ${PRIVILEGED} -p 8023:22 -v /tmp/:/host ${IMG_NAME}"
echo "--> Executing: ${DOCKER_COMMAND}"
sh -c "${DOCKER_COMMAND}"
