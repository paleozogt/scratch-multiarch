#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
set -u

imagefrom=$1
imageto=$2
archtag=$3

# arch name mapping
if [[ "$archtag" == "arm64v8" ]]; then
    arch=arm64
    archvariant=v8
elif [[ "$archtag" == "arm32v7" ]]; then
    arch=arm
    archvariant=v7
elif [[ "$archtag" == "arm32v5" ]]; then
    arch=arm
    archvariant=v5
elif [[ "$archtag" == "i386" ]]; then
    arch=386
    archvariant='null'
else
    arch=$archtag
    archvariant='null'
fi

echo archtag=$archtag
echo arch=$arch
echo archvariant=$archvariant

$DIR/lib/docker-copyedit/docker-copyedit.py FROM $imagefrom INTO $imageto:$archtag \
    set arch $arch set variant $archvariant
newarch=$(docker inspect $imageto:$archtag | jq -r .[].Architecture)
newvariant=$(docker inspect $imageto:$archtag | jq -r .[].Variant)
echo created $imageto:$archtag with arch metadata $newarch $newvariant
