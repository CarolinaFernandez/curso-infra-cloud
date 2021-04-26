# Curso de infraestructura cloud

Este repositorio provee de documentación y ejecutables para probar herramientas de virtualización, cloud privado y NFV, en concreto de las siguientes:

- DevStack (Victoria)
- Docker (20.10.6)
- Kubernetes (1.21)
- OSM (NINE)

## Requisitos

### Recursos mínimos

- vCPUs: 2 (DevStack), 2 (Docker), 6 (Kubernetes), 2 (OSM)
- RAM: 6GB (DevStack), 4GB (Docker), 6GB (Kubernetes), 6GB (OSM)
- Disco: 9.1GB/60GB (DevStack), 2.2GB/40GB (Docker), 8.8GB/120GB (Kubernetes), 18GB/40GB (OSM)

### Sistemas operativos

- Ubuntu 20.04.2 LTS
- Windows 10

### Herramientas

- [Vagrant](https://www.vagrantup.com/docs/installation) 2.2.13 o superior

# Uso

## Entornos Unix

```bash
# Iniciar VM
./env/unix/start.sh [devstack|docker|kubernetes|osm]
# Conectar a VM
./env/unix/connect.sh (devstack|docker|osm)
./env/unix/connect.sh kubernetes [kubeadmin|kubenode01|kubenode02]
# Parar VM
./env/unix/stop.sh [devstack|docker|kubernetes|osm]
# Eliminar VM
./env/unix/delete.sh [devstack|docker|kubernetes|osm]
```

## Entornos Windows

```bash
# Iniciar VM
%cd%/env/unix/start.bat (devstack|docker|kubernetes|osm)
# Conectar a VM
%cd%/env/unix/connect.bat (devstack|docker|osm)
%cd%/env/unix/connect.bat kubernetes [kubeadmin|kubenode01|kubenode02]
# Parar VM
%cd%/env/unix/stop.bat [devstack|docker|kubernetes|osm]
# Eliminar VM
%cd%/env/unix/delete.bat [devstack|docker|kubernetes|osm]
```

# Autores

[Carolina Fernandez](https://github.com/CarolinaFernandez)
