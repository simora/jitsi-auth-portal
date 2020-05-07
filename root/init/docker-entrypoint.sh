#!/bin/bash

mkdir /config/init
cp -n /init/entrypoint.sh /config/init/entrypoint.sh

/config/init/entrypoint.sh
