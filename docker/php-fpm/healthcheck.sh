#!/bin/sh
set -e

SCRIPT="/srv/app/public/index.php"

if env -i REQUEST_METHOD=GET SCRIPT_NAME=/index.php SCRIPT_FILENAME=$SCRIPT cgi-fcgi -bind -connect 127.0.0.1:9000 > /dev/null; then
    exit 0
fi

exit 1