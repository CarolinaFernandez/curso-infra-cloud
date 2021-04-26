#!/bin/bash

##
# Enter to the Vagrant environment
#

# Access specific environment
TOOL=$1
readarray -t tools < <(find ${PWD}/tools -maxdepth 1 -type d -printf "%P\n")
[[ -z $TOOL ]] && echo "Error: se ha de definir el entorno a acceder (${tools[@]})" && exit 1
# Use specific node
NODE=$2
current=$PWD

tool_path="tools/${TOOL}"
if [[ -d $tool_path ]]; then
    cd $tool_path
else
    echo "Error: entorno inexistente"
    exit 1
fi

# SSH the VM
echo "Accediendo a la VM (${TOOL})"
vagrant ssh $NODE

cd $current
