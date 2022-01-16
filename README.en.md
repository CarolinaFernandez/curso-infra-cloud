# Cloud infrastructure course

This repository provides documentation and executables to test virtualisation, private cloud and NFV tools. The exhaustive list is as follows:

- DevStack (Xena)
- Docker (20.10.12)
- Kubernetes (1.23)
- OSM (TEN)

## Requisites

### Minimum resources

- vCPUs: 2 (DevStack), 2 (Docker), 6 (Kubernetes), 2 (OSM)
- RAM: 6GB (DevStack), 4GB (Docker), 6GB (Kubernetes), 6GB (OSM)
- Disk: 9.1GB/60GB (DevStack), 2.2GB/40GB (Docker), 8.8GB/120GB (Kubernetes), 18GB/40GB (OSM)

### Operating Systems

- Ubuntu 20.04.2 LTS
- Windows 10

### Tools

- [Vagrant](https://www.vagrantup.com/docs/installation) 2.2.7 or higher
- [VirtualBox](https://www.oracle.com/virtualization/technologies/vm/downloads/virtualbox-downloads.html) 6.1.26 or lower

**Note**: in VirtualBox 6.1.28 and higher versions there is an error when assigniing the IP in the private network. If impacted by this error, follow [these steps](https://superuser.com/questions/1691783/cannot-create-a-private-network-from-vagrant-in-virtualbox-after-updating-it), creating the file */etc/vbox/networks.conf* and introducing the line `* 0.0.0.0/0 ::/0`.

# Usage

## Unix environments

```bash
# Start VM
./env/unix/start.sh [devstack|docker|kubernetes|osm]
# Attach to VM
./env/unix/connect.sh (devstack|docker|osm)
./env/unix/connect.sh kubernetes [cp|worker1|worker2]
# Stop VM
./env/unix/stop.sh [devstack|docker|kubernetes|osm]
# Delete VM
./env/unix/delete.sh [devstack|docker|kubernetes|osm]
```

## Windows environments

```bash
# Start VM
%cd%/env/windows/start.bat (devstack|docker|kubernetes|osm)
# Attach to VM
%cd%/env/windows/connect.bat (devstack|docker|osm)
%cd%/env/windows/connect.bat kubernetes [cp|worker1|worker2]
# Stop VM
%cd%/env/windows/stop.bat [devstack|docker|kubernetes|osm]
# Delete VM
%cd%/env/windows/delete.bat [devstack|docker|kubernetes|osm]
```

*Note*: if no parameter is indicated, accessing the Kubernetes environment will attach to the *cp* (k8scp) node.

# Documentation and scripts

The directory of each tool contains certain resources.

Some of them are used to setup the environment:

- Configuration file: available under *tools/devstack/resources/cfg* and used to bootstrap the environment with configuration variables
- Booting scripts: available under *tools/\*\*/resources/script/setup* with the aim of helping deploying the environment
- Keypair: available under  *tools/(devstack|osm)/resources/key* and used to ease the access to the VMs created during the tests

Other files are available in Spanish language within the VMs (under the user `$HOME`) to follow up these steps:

- Usage guide: available under *tools/\*\*/resources/doc/README.md* as a reference to follow specific steps
- Operation scripts: available under *tools/\*\*/resources/script/operation* and used to replicate the steps in the abovementioned guide

# Authors

[Carolina Fernandez](https://github.com/CarolinaFernandez)
