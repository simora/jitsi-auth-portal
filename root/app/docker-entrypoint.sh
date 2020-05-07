#!/bin/bash

mkdir /config/init
[[ ! -f /config/init/entrypoint.sh ]] && cp /app/entrypoint.sh /config/init/entrypoint.sh
chmod +x /config/init/entrypoint.sh

/config/init/entrypoint.sh
