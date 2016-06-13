#!/bin/bash
set -e

cd "$(dirname "$(readlink -n "$BASH_SOURCE")")"

url='git://github.com/Alroniks/docker-tao'

echo '# maintainer: Ivan Klimchuk <ivan@klimchuk.com> (@alroniks)'

defaultVariant='apache'

for variant in apache fpm; do
    commit="$(git log -1 --format='format:%H' -- "$variant")"
    fullVersion="$(grep -m1 'ENV TAO_VERSION ' "$variant/Dockerfile" | cut -d' ' -f3)"

    versionAliases=()
    while [ "${fullVersion%.*}" != "$fullVersion" ]; do
        versionAliases+=( $fullVersion-$variant )
        if [ "$variant" = "$defaultVariant" ]; then
            versionAliases+=( $fullVersion )
        fi
        fullVersion="${fullVersion%.*}"
    done
    versionAliases+=( $fullVersion-$variant $variant )
    if [ "$variant" = "$defaultVariant" ]; then
        versionAliases+=( $fullVersion latest )
    fi

    echo
    for va in "${versionAliases[@]}"; do
        echo "$va: ${url}@${commit} $variant"
    done
done