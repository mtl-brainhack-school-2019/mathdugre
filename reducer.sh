#!/bin/bash

# Parse arguments
while getopts "i:o:c:p:" opt; do
    case $opt in
        i) INPUT_IMG=$OPTARG    ;;
        o) OUTPUT_IMG=$OPTARG   ;;
        c) COMMAND_FILE=$OPTARG ;;
        p) PRUNED_DIR=$OPTARG   ;;
        *) echo "fatal error: ${OPTARG} invalid arguments" >&2
           exit 1
    esac
done

if [ -z $INPUT_IMG ]; then
    echo 'fatal error: Input image is required' >&2
    exit 1
fi

if [ -z $OUTPUT_IMG ]; then
    echo 'fatal error: Output image is required' >&2
    exit 1
fi

if [ -z $COMMAND_FILE ]; then
    echo 'fatal error: Path to the command file is required' >&2
    exit 1
elif [ ! -f "$COMMAND_FILE" ]; then
    echo 'fatal error: Command file must be a file' >&2
    exit 1
fi

if [[ ! -f "$PRUNED_DIR" ]]; then
    echo 'fatal error: Pruned needs to be a file with listed directories' >&2
    exit 1
fi

# Build image with reprozip
docker run --rm -d --entrypoint='bash' --name='tmp' $INPUT_IMG
OS=$(docker exec -it tmp 'source /etc/os-release; echo $ID')
docker stop tmp

CMD_INSTALL=""
if [[ $OS = "ubuntu" || $OS = "debian" ]]; then
    CMD_INSTALL='apt-get install python python-dev python-pip gcc libsqlite3-dev libssl-dev libffi-dev'
elif [[ $OS = "fedora" || $OS = "centos" ]]; then
    CMD_INSTALL='yum install python python-devel gcc sqlite-devel openssl-devel libffi-devel'
else
    echo "OS is not supported"
    return 1
fi

cat > Dockerfile << EOF
    FROM $INPUT_IMG
    
    RUN $PPACKAGE_MANAGE update \
    && $CMD_INSTALL
EOF


# Run the container
#$DOCKER_FLAGS="-v $PWD/data:/data -v $PWD/outputs:/outputs -v $PWD/simg/bids-example:/reprozip --name reprozip"
docker run -itd --entrypoint="bash" --security-opt=seccomp:unconfined $DOCKER_FLAGS --name="reprozip" bids/example




