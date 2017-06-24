#!/bin/bash

packer validate packer_image.json
if [ "$?" -ne 0 ]; then
   echo "error: invalid packer template"
   exit 1
fi

packer build packer_image.json
