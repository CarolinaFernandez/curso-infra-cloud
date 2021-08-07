# Curso de infraestructura cloud

Este repositorio provee de documentación y ejecutables para probar herramientas de virtualización, cloud privado y NFV, en concreto de las siguientes:

- DevStack (Wallaby)
- Docker (20.10.6)
- Kubernetes (1.21)
- OSM (TEN)

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
%cd%/env/windows/start.bat (devstack|docker|kubernetes|osm)
# Conectar a VM
%cd%/env/windows/connect.bat (devstack|docker|osm)
%cd%/env/windows/connect.bat kubernetes [kubeadmin|kubenode01|kubenode02]
# Parar VM
%cd%/env/windows/stop.bat [devstack|docker|kubernetes|osm]
# Eliminar VM
%cd%/env/windows/delete.bat [devstack|docker|kubernetes|osm]
```

*Nota*: si no se indica un parámetro, el acceso al entorno de Kubernetes se realizará al nodo *master* (kubeadmin).

# Documentación y scripts

Dentro del directorio de cada herramienta se incluyen ciertos recursos.

Parte de ellos se usan para la preparación del entorno:

- Archivo de configuración: disponible bajo *tools/devstack/resources/cfg* y usado para iniciar el entorno con variables de configuración
- Scripts de inicio: disponibles bajo *tools/\*\*/resources/script/setup* con la finalidad es ayudar a desplegar el entorno
- Par de claves: disponibles bajo  *tools/(devstack|osm)/resources/key* y usadas para facilitar el acceso a las máquinas que se creen durante las pruebas

Y otros están disponibles dentro de las máquinas (bajo la `$HOME` del usuario) para poder seguir los diferentes pasos:

- Guía de uso: disponible bajo *tools/\*\*/resources/doc/README.md* como referencia de los pasos a seguir
- Scripts de operación: disponibles bajo *tools/\*\*/resources/script/operation* y usados para replicar los pasos de la guía

# Autores

[Carolina Fernandez](https://github.com/CarolinaFernandez)
