#!/usr/bin/env bash

##
# Stop the Vagrant environment
#

# Access specific environment
TOOL=$1
readarray -t tools < <(find ${PWD}/tools -maxdepth 1 -type d -printf "%P\n")
[[ -z $TOOL ]] && echo "Error: se ha de definir el entorno a parar (${tools[@]})" && exit 1
current=$PWD

tool_path="tools/${TOOL}"
if [[ -d $tool_path ]]; then
    cd $tool_path
else
    echo "Error: entorno inexistente"
    exit 1
fi

# Stop the VM
echo "Parando la VM (${TOOL})"
vagrant halt

cd $current
