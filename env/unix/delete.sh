#!/bin/bash

##
# Terminate and delete the Vagrant environment
#

# Access specific environment
TOOL=$1
readarray -t tools < <(find ${PWD}/tools -maxdepth 1 -type d -printf "%P\n")
[[ -z $TOOL ]] && echo "Error: se ha de definir el entorno a eliminar (${tools[@]})" && exit 1
current=$PWD

tool_path="tools/${TOOL}"
if [[ -d $tool_path ]]; then
    cd $tool_path
else
    echo "Error: entorno inexistente"
    exit 1
fi

# Remove the VM
echo "Eliminando la VM (${TOOL})"
vagrant destroy --force

cd $current
