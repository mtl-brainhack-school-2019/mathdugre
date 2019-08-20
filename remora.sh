#!/bin/bash

# Parse arguments
while getopts "hi:o:c:p:" opt; do
    case $opt in
        i) INPUT_IMG=$OPTARG    ;;
        c) COMMAND_FILE=$OPTARG ;;
        *) echo "usage: sh reducer.sh -i <INPUT_IMG> -c <COMMAND_FILE>" 
           exit 1
    esac
done

if [ -z ${INPUT_IMG} ]; then
    echo 'fatal error: Input image is required' >&2
    exit 1
fi

if [ -z ${COMMAND_FILE} ]; then
    echo 'fatal error: Path to the command file is required' >&2
    exit 1
elif [ ! -f "${COMMAND_FILE}" ]; then
    echo 'fatal error: Command file must be a file' >&2
    exit 1
fi

# Test if reprounzip is installed
if ! type "reprounzip" > /dev/null; then
    echo ' fatal error: Reprounzip is required.' \
         ' Install using "pip install reprounzip"' >&2
    exit 2 
fi

# Build image with reprozip
echo "Building image with reprozip..."
mkdir -p tmp
docker run --rm -itd --entrypoint='bash' -v ${PWD}/tmp:/reprozip --name='tmp' ${INPUT_IMG}
docker exec -it tmp bash -c 'source /etc/os-release; echo $ID > /reprozip/os.txt'
OS=$(cat tmp/os.txt)
docker stop tmp

CMD_INSTALL=""
PACKAGE_MANAGER=""
if [ $OS = 'ubuntu' ] || [ $OS = 'debian' ]; then
    CMD_INSTALL='apt-get -y -q install python python-dev python-pip gcc libsqlite3-dev libssl-dev libffi-dev'
    PACKAGE_MANAGER='apt-get'
elif [ $OS = 'fedora' ] || [ $OS = 'centos' ]; then
    CMD_INSTALL='yum install -y -q python python-devel gcc sqlite-devel openssl-devel libffi-devel'
    PACKAGE_MANAGER='yum'
else
    echo "$OS is not supported"
    exit 1
fi

cat > Dockerfile << EOF
FROM ${INPUT_IMG}
    
RUN ${PACKAGE_MANAGER} update -q \
    && ${CMD_INSTALL}

RUN pip install -U reprozip
EOF

docker build -t tmp .

# Run the container
echo "Retrieving file with reprozip..."
cp ${COMMAND_FILE} ./tmp/
chmod +x ./tmp/${COMMAND_FILE}
docker run --rm -itd --entrypoint="bash" --security-opt=seccomp:unconfined ${DOCKER_FLAG} -v ${PWD}/tmp:/reprozip --name="reprozip" tmp
docker exec -it reprozip bash -c "cd reprozip; reprozip trace sh ${COMMAND_FILE}; reprozip pack reduced-img"
docker stop reprozip
docker image rm tmp

echo "Create reduced image..."
cd tmp
reprounzip directory setup reduced-img.rpz reduced-img
cd ..

cat > Dockerfile << EOF
FROM $OS
    
COPY tmp/reduced-img/root /

RUN rm -r /bids_dataset \
    && rm -r /reprozip
EOF

echo "DONE"
echo "Remove the tmp folder in the current directory if you want to save space"
