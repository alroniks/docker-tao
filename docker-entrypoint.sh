#!/bin/bash
set -e

if ! [ -e index.php ]; then
    
    echo >&2 "TAO not found in $(pwd) - copying now..."

    if [ "$(ls -A)" ]; then

        echo >&2 "WARNING: $(pwd) is not empty - press Ctrl+C now if this is an error!"
        
        ( set -x; ls -A; sleep 10 )
    fi

    tar cf - --one-file-system -C /usr/src/tao . | tar xf -

    find . -type f -exec chmod 644 {} \;
    find . -type d -exec chmod 755 {} \;

    echo >&2 "Complete! TAO has been successfully copied to $(pwd)"
fi

exec "$@"