#!/bin/bash

packer validate web.json
if [ "$?" -ne 0 ]; then
   echo "error: invalid packer template web.json"
   exit 1
fi

packer build web.json

packer validate celery.json
if [ "$?" -ne 0 ]; then
   echo "error: invalid packer template celery.json"
   exit 1
fi

packer build celery.json
