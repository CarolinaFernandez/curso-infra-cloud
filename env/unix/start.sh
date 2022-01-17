#!/usr/bin/env bash

##
# Start the Vagrant environment
#

# Access specific environment
TOOL=$1
readarray -t tools < <(find ${PWD}/tools -maxdepth 1 -type d -printf "%P\n")
[[ -z $TOOL ]] && echo "Error: se ha de definir el entorno a iniciar (${tools[@]})" && exit 1
current=$PWD

tool_path="tools/${TOOL}"
if [[ -d $tool_path ]]; then
    cd $tool_path
else
    echo "Error: entorno inexistente"
    exit 1
fi

# Install required plugin
must_install_plugin=1
[[ $(vagrant plugin list) =~ "vagrant-disksize" ]] && must_install_plugin=0
if [[ $must_install_plugin -eq 1 ]]; then
    echo "Instalando plug-in de Vagrant"
    vagrant plugin install vagrant-disksize
fi
# Set environment as VAGRANT_EXPERIMENTAL
## See: https://www.vagrantup.com/docs/provisioning/basic_usage
#export VAGRANT_EXPERIMENTAL="dependency_provisioners"

# Do reload only when it was not already created or currently running
if [[ $(vagrant status) =~ "running" ]]; then
    must_start=0
    must_reload=0
elif [[ $(vagrant status) =~ "poweroff" ]]; then
    must_start=1
    must_reload=0
else
    must_start=1
    must_reload=1
fi

# Adapt the Vagrantfile to UNIX
# Removing the subnet mask circumvents routing issues
sed -i 's/\, netmask\: .*//g' Vagrantfile
chmod 644 Vagrantfile

# Create the VM
if [[ $must_start -eq 1 ]]; then
    echo "Creando la VM (${TOOL})"
    vagrant up
else
    echo "Iniciando la VM (${TOOL})"
fi

# Reload the VM
if [[ $must_reload -eq 1 ]]; then
    echo "Reiniciando tras crear la VM (${TOOL})"
    vagrant reload
fi

# Restore the original Vagrantfile, previously adapted to UNIX
# Removing the subnet mask circumvents routing issues
git checkout Vagrantfile

# SSH into the VM
echo "Accediendo a la VM (${TOOL})"
vagrant ssh

cd $current
