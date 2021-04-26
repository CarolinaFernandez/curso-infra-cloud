# Introducción a OSM

En primer lugar se ha de acceder a $HOME/scripts.

```bash
cd ~/scripts
```

En este directorio se encuentra una serie de ejecutables con diferentes opciones a probar.

# Pasos iniciales

Antes de poder realizar cualquier operación mediante esta herramienta se ha de realizar cierta configuración mínima.
En concreto, se ha de conectar con una infraestructura (VIM) que despliegue los servicios, así como subir los paquetes de funciones y servicios que se van a instanciar. 

*Nota: se asume que la VIM está igualmente configurada para habilitar la conexión con las credenciales y clave proporcionadas, así como disponer de las imágenes necesarias para correr los servicios.*

## Conectar con una VIM

Los datos necesarios para la conexión se proporcionan por otro canal y se han de rellenar a mano, substituyendo así el valor de las siguientes cuatro variables.

```bash
VIM_NAME="openstack-vim-local"
VIM_URL="http://192.168.33.112/identity/v3/"
TENANT="admin"
USER="admin"
PASSWORD="secret"
./vim-register.sh $VIM_NAME $VIM_URL $TENANT $USER $PASSWORD
```

Una vez registrada, se puede obtener la ID que le da OSM y su estado operativo.

```bash
./vims-list.sh
```

También se pueden obtener detalles de una VIM en concreto mediante su ID o nombre.

```bash
VIM_ID="openstack-vim-local"
./vim-show.sh $VIM_ID
```

## Generar paquetes

Cada función (VNF) y servicio (NS) se describe mediante unos archivos, que se distribuyen mediante sendos paquetes. Dichos paquetes se pueden descargar directamente o generar manualmente a partir de su información.

En este caso se seguirá el segundo enfoque, usando el repositorio oficial descargado en `/opt/osm/osm-packages`. En este directorio se puede buscar el nombre del servicio deseado, de modo que se pase por parámetro al script para generar los paquetes para la VNF y el NS.

```bash
PKG_NAME="hackfest_basic"
./packages-generate.sh $PKG_NAME
```

# Uso

## Registrar paquetes en OSM

Una vez se dispone de los paquetes de un servicio, y de forma previa a poder instanciarlo, hay que registrarlo en OSM. Este proceso se llama *onboarding*. En el script en uso se pasa el nombre del paquete como parámetro.

```bash
PKG_NAME="hackfest_basic"
./packages-onboard.sh $PKG_NAME
```

*Nota: los pasos de generación y registro de paquetes se pueden combinar en un único paso, usando los comandos "osm vnfpkg-create" y "osm nspkg-create"*

## Inspeccionar funciones y servicios disponibles

Tras el registro en la herramienta de orquestación se puede proceder a consultar sus detalles. Esto permite saber su ID dentro del sistema y el tipo de descriptor usado para las funciones.

```bash
./packages-list.sh
```

## Instanciar servicio

Una vez registrado el servicio ya se puede instanciar o desplegar el mismo mediante la herramienta. Basta con pasar por parámetro el nombre del servicio y el nombre o ID de la VIM.

```bash
PKG_NAME="hackfest_basic-ns"
VIM_ID="openstack-vim-local"
./package-instantiate.sh $PKG_NAME $VIM_ID
```

## Inspeccionar instancias de servicios activos

Al desplegar uno o más paquetes de servicios se obtienen instancias de servicios de red. Se pueden realizar consultas sobre los detalles de estos servicios en activo para obtener información como su ID dentro del sistema, su estado, las operaciones en curso que ejecutan o un resumen de algún error, de haberlo.

Igualmente, cada servicio contiene una o más funciones de red, cuyos detalles (a un nivel lógico, como elemento constituyente del servicio) también se pueden consultar.

```bash
./services-list.sh
```

También se pueden obtener detalles de la instancia del servicio, pasando la ID de éste, obtenida mediante la lista anterior.

```bash
SRV_ID="..."
./service-show.sh $SRV_ID
```

Una vez el servicio ha cumplido su cometido, se puede eliminar.

```bash
SRV_ID="..."
./service-delete.sh $SRV_ID
```

## Control de acceso: proyectos y usuarios

Como en otras herramientas, las abstracciones de proyectos y usuarios sirven para aplicar el control de acceso.

En primer lugar se ha de definir un proyecto. Opcionalmente se pueden indicar una serie de restricciones, o cuotas, que aplicar a los usuarios relacionados con el proyecto.

```bash
PROJECT="cloudinfra"
osm project-create $PROJECT --quotas="vnfds=2,nsds=2,ns_instances=2,vim_accounts=2,k8sclusters=1,osmrepos=0,k8srepos=0"

# O, de forma alternativa:
./project-create.sh
```

Una vez creado, se puede consultar la lista de proyectos disponibles.

```bash
./projects-list.sh
```

Luego se procede a la creación de usuarios, cada uno enlazado al proyecto pertinente.

```bash
USER="cloudinfra"
PASSWORD="password"
PROJECT="cloudinfra"
osm user-create $USER --password $PASSWORD --projects $PROJECT

# O, de forma alternativa:
./user-create.sh
```

Finalmente se puede consultar también la lista de usuarios en el sistema.

```bash
./users-list.sh
```
