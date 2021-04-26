#!/bin/bash

PKG_NAME=$1

[[ -z $PKG_NAME ]] && echo "Error: falta informacion: nombre del paquete" && exit 1

current=$PWD
cd /opt/osm/osm-packages

# Note: some packages are not named accordingly ("_vnf", "_ns")
# but instead using an extra "d" ("_vnfd", "_nsd"), or even
# different types of *NFs are in use ("knf", "pnf")
pkg_types=(vnf vnfd knf pnf ns nsd nst)
for pt in "${pkg_types[@]}"; do
    PKG_NAME=${PKG_NAME//\.tar\.gz/}
    # Adjust name to filter out the ending indicators/types
    PKG_NAME=${PKG_NAME//_vnfd/}
    PKG_NAME=${PKG_NAME//_vnf/}
    PKG_NAME=${PKG_NAME//_knf/}
    PKG_NAME=${PKG_NAME//_pnf/}
    PKG_NAME=${PKG_NAME//_nsd/}
    PKG_NAME=${PKG_NAME//_ns/}
    pkg_filename="${PKG_NAME}_${pt}.tar.gz"
    [[ -f ${pkg_filename} ]] && osm upload-package ${pkg_filename}
done

cd $current
