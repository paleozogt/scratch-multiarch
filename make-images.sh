#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
set -u
image=$1
images=""

docker build . -t $image:temp
for archtag in i386 amd64 arm32v5 arm32v7 arm64v8 mips mipsle mips64 mips64le ppc ppc64 ppc64le riscv riscv64 s390 s390x sparc sparc64; do
   $DIR/change-image-arch.sh $image:temp $image $archtag
   images="$images $image:$archtag"
done
docker rmi $image:temp

for i in $images; do
    docker push $i
done

set -x
docker manifest rm $image
docker manifest create $image $images
docker manifest push $image
