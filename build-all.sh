#!/bin/bash

declare -a VERSIONS=(32RC2-php56 32RC2-php70 32RC2-php71 32RC2-php72 32RC2-php73)

for TAOVER in ${VERSIONS}
do
    echo "Building image of tao, version is $TAOVER"
    docker build -f Dockerfile-$TAOVER -t alroniks/tao:$TAOVER .
    docker push alroniks/tao:$TAOVER
done

