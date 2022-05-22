#!/bin/bash
if  [ ! "$1" ] ;then
    echo "You have not entered a version"
    exit
fi
version=$1
echo -e "\033[36mRun for version: ${version}\033[0m"

service_name="elastic-crack"
docker stop ${service_name}
docker rm ${service_name}


docker build --no-cache -f Dockerfile \
  --build-arg VERSION="${version}" \
  --tag ${service_name}:${version} .

docker run -it --rm \
  -v $(pwd)/output:/crack/output \
  ${service_name}:${version}
