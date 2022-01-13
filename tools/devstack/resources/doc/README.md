# Introducción a OpenStack

En primer lugar se ha de acceder a $HOME/scripts.

```bash
cd ~/scripts
```

En este directorio se encuentra una serie de ejecutables con diferentes opciones a probar.

# Pasos iniciales

Antes de poder realizar cualquier operación mediante esta herramienta se ha de realizar cierta configuración mínima.
A fin de poder operar con la herramienta de CLI que ofrece el comando "openstack" se han de configurar las variables de entorno con las credenciales necesarias.

## Preparación del entorno de CLI

Hay dos maneras de obtener las credenciales de OpenStack para un proyecto (tenant) y usuario.
En ambos casos se trata de un archivo llamado "openrc" que incluye variables de inciialización para usar con un usuario y proyecto específico.

El primer modo es a través de la interfaz gráfica de la instancia OpenStack, en concreto a la sección que aloja el [archivo RC](http://localhost:8081/dashboard/project/api_access/openrc/), que es el que carga dichas variables. Luego se ha de copiar el contenido en un archivo dentro de la VM, por ejemplo bajo ~/openrc.sh.

En el otro modo, en que se dispone de acceso a la instancia de OpenStack, basta con copiar el archivo autogenerado:

```bash
cp /opt/devstack/openrc ~/openrc.sh
```

*Nota*: en este caso el usuario y proyecto predeterminado del archivo "openrc" es "demo" y por tanto *no* permite acceso como administrador, por lo que algunas funciones no están operativas.

En ambos casos se carga este archivo y se introduce el password si es necesario.

```bash
# Opción A: como usuario y proyecto por defecto del archivo
source ~/openrc.sh
# Opción B: como usuario y proyecto determinados (pasados por parámetro)
source /opt/devstack/openrc admin admin
```

Con esto ya se puede empezar a operar con la CLI.

# Uso

## Registrar imágenes

OpenStack debe tener a su disposición las imágenes de los diferentes sistemas operativos que puede instanciar.
En primer lugar, se descarga la imagen o imágenes deseadas y luego se registran en la plataforma.

```bash
./image-create-cirros.sh
./image-create-ubuntu.sh
```

Una vez registradas, se puede ver la lista de imágenes disponibles.

```bash
./images-list.sh
```

También se puede mirar el detalle de alguna de ellas, pasando por parámetro su nombre o ID.

```bash
IMG_ID="cirros-0.3.5-x86_64-disk.img"
./image-show.sh $IMG_ID
```

## Crear *flavors*

Un *flavor* es una especie de *template* con parámetros rellenados de las máquinas virtuales y que se usa para definir los recurso que ésta consumirá. Por ejemplo, los núcleos, memoria o disco.

En este ejemplo se creará un *flavor* con 1 vCPU, 1GB de RAM y 5 GB de disco.

```bash
./flavor-create.sh
```

Una vez creado, se puede mirar éste y otros *flavors* disponibles.

```bash
./flavors-list.sh
```

O bien mostrar los detalles de un *flavor*, pasando por parámetro el nombre o ID del mismo.

```bash
FLAVOR_ID="c1r1Gd5G"
./flavor-show.sh $FLAVOR_ID
```

## Crear pares de claves

Para poder acceder mediante SSH a las instancias con mayor capacidad de automatización y seguridad se suele usar un par de claves. Esto es especialmente en algunas imágenes preparadas para *cloud* que no admiten configuración mediante password.

Con este script se generará una clave RSA y se registrará en la plataforma.

```bash
./keypair-create.sh
```

## Crear redes

El uso de redes virtualizadas es crucial en OpenStack para conectar las instancias entre sí, o bien aislarlas.
En este caso se proceden a crear redes y subredes virtuales de forma simple, para que luego las instancias de computación puedan coneconectar sus interfaces a ellas.

```bash
NET_NAME="mgmtnet"
SUBNET_CIDR_NM="10.10.20.0"
SUBNET_MASK="24"
./network-create.sh $NET_NAME $SUBNET_CIDR_NM $SUBNET_MASK

NET_NAME="privnet1"
SUBNET_CIDR_NM="10.10.50.0"
SUBNET_MASK="24"
./network-create.sh $NET_NAME $SUBNET_CIDR_NM $SUBNET_MASK

NET_NAME="privnet2"
SUBNET_CIDR_NM="10.10.60.0"
SUBNET_MASK="24"
./network-create.sh $NET_NAME $SUBNET_CIDR_NM $SUBNET_MASK
```

Tras la creación se procede a ver la lista de redes y subredes.

```bash
./networks-list.sh
```

## Definir puertos

Una de las abstracciones relacionadas con las redes son los puertos: una suerte de interfaces con ciertos datos preconfigurados, por ejemplo su IP. De este modo es posible conectar una máquina virtual con una IP estática, en lugar de depender de la IP que asigna el DHCP de la red.

```bash
PORT_NAME="privnet1-port"
NETWORK_ID="privnet1"
SUBNETWORK_ID="privnet1-subnet"
IP_ADDR="10.10.50.3"
./port-create.sh $PORT_NAME $NETWORK_ID $SUBNETWORK_ID $IP_ADDR

PORT_NAME="privnet2-port"
NETWORK_ID="privnet2"
SUBNETWORK_ID="privnet2-subnet"
IP_ADDR="10.10.60.3"
./port-create.sh $PORT_NAME $NETWORK_ID $SUBNETWORK_ID $IP_ADDR
```

Como en los casos anteriores, se puede consultar la lista de los puertos disponibles.

```bash
./ports-list.sh
```

O bien mostrar los detalles de un puerto determinado, pasando su nombre ID por parámetro.

```bash
PORT_ID="privnet2-port"
./port-show.sh $PORT_ID
```

## Crear *routers*

Otra de las abstracciones de red son los *routers* virtuales.
Igual que con uno físico, permiten conectar redes L3 diferentes entre sí, de forma que las instancias de computación que se encuentren inicialmente en redes diferentes también puedan conectarse entre sí.

Primero se crea el *router* en sí.

```bash
ROUTER_NAME="router-priv1topriv2"
./router-create.sh $ROUTER_NAME
```

Luego se conectan las diferentes subredes que se quiere hacer visibles entre sí.

```bash
ROUTER_NAME="router-priv1topriv2"
SUBNET_NAME="privnet1-subnet"
./router-subnet-connect.sh $ROUTER_NAME $SUBNET_NAME

SUBNET_NAME="privnet2-subnet"
./router-subnet-connect.sh $ROUTER_NAME $SUBNET_NAME
```

Tras esto, se puede mirar la lista de *routers*.

```bash
./routers-list.sh
```

Y luego obtener detalles de un *router* concreto.

```bash
ROUTER_ID="router-priv1topriv2"
./router-show.sh $ROUTER_ID
```

## Definir *security groups*

De cara a configurar el acceso a las redes se definen las reglas de acceso del tráfico entrante y saliente de cada instancia de computación o VM. Esta agrupación de reglas se conoce como *security group*.

Para ello, primero se crea un grupo con unas reglas iniciales, imitando las del grupo de seguridad por defecto e incorporando algunas para permitir el acceso mediante SSH.

```bash
./securitygroup-create.sh
```

Luego se pueden observar los diferentes *security groups* disponibles.

```bash
./securitygroups-list.sh
```

O bien consultar los detalles de un *security group* concreto, pasando su ID o nombre, así como de las reglas contenidas.


```bash
SECGROUP_ID="cloudinfra-sec"
./securitygroup-show.sh $SECGROUP_ID
```

## Instanciar máquinas virtuales

Cuando ya se dispone de todo lo anterior, se procede a la creación de una VM que utilice una imagen, *flavor* y rede determinado. Éste es el recurso llamado *server* en OpenStack.

```bash
IMG_NAME="cirros-0.3.5-x86_64-disk.img"
FLV_NAME="c1r1Gd5G"
SECGROUP_NAME="cloudinfra-sec"
KEY_NAME="cloudinfra-keypair"

SRV_NAME="cirros-test0"
NETWORK_NAME="mgmtnet"
./server-create.sh $SRV_NAME $IMG_NAME $FLV_NAME $SECGROUP_NAME $KEY_NAME $NETWORK_NAME

SRV_NAME="cirros-test1"
PORT_NAME="privnet1-port"
./server-create-port.sh $SRV_NAME $IMG_NAME $FLV_NAME $SECGROUP_NAME $KEY_NAME $PORT_NAME

SRV_NAME="cirros-test2"
PORT_NAME="privnet2-port"
./server-create-port.sh $SRV_NAME $IMG_NAME $FLV_NAME $SECGROUP_NAME $KEY_NAME $PORT_NAME
```

Una vez creadas, se puede consultar la lista de instancias de máquinas virtuales disponibles.

```bash
./servers-list.sh
```

Así como los detalles de una instancia disponible, pasando su nombre o ID.

```bash
SRV_NAME="cirros-test1"
./server-show.sh $SRV_NAME
```

También se pueden eliminar fácilmente. En este caso se borra la instancia que no se va a usar en la prueba de conectividad.

```bash
SRV_NAME="cirros-test0"
./server-delete.sh $SRV_NAME
```

Hecho esto, se puede acceder a Horizon, acceder a cada una de las dos VMs por VNC (integrado en la interfaz bajo el nombre "Console") y hacer un ping desde una a la otra, cada una en una red diferente y conectadas por el router virtual creado previamente.

Tras la prueba, se borran dichas instancias.

```bash
SRV_NAME="cirros-test1"
./server-delete.sh $SRV_NAME
SRV_NAME="cirros-test2"
./server-delete.sh $SRV_NAME
```

## Avanzado

### Instalación de plugins

OpenStack permite la instalación de diferentes servicios o componentes que extienden la funcionalidad inicial de una instancia determinada de OpenStack. En el caso de DevStack, la instalación de diferentes servicios se hace mediante la directiva "enable_plugin" en el archivo "local.conf" (situado en "tools/devstack/resources/cfg/devstack-local.conf" en este repositorio).

Si se descomenta (con un nivel de "#") la sección de "Ceilometer" en dicho archivo tras borrar e iniviar la VM, aparte de la orquestación con *Heat* se instalará *Ceilometer* para la monitorización.

*Nota: una vez hecho eso, DevStack necesitará más recursos (asegúrate de que tu entorno puede con ellos o incrementa la memoria RAM en el archivo Vagrantfile pertinente.*

Se puede validar la instalación de los servicios comprobando la lista de servicios en activo.

```bash
$ openstack service list
+----------------------------------+-------------+----------------+
| ID                               | Name        | Type           |
+----------------------------------+-------------+----------------+
| 09202e7c0eb64724882d624ae58aeeef | cinderv3    | volumev3       |
| 102d5f20300b4733989aa308dd92ab16 | cinder      | block-storage  |
| 1b2b6e0901bc4755b9ee01c35ef969c4 | nova_legacy | compute_legacy |
| 470351cfa2b34d0bbe35d9ac7b3676d2 | neutron     | network        |
| 5e5fe066c72e4347a6d6c9ed78c79c77 | placement   | placement      |
| 64dba5fd29844b62a731aa30048b38c0 | keystone    | identity       |
| 67e47715f9534159a6c74878c89fe5d7 | heat-cfn    | cloudformation |
| 93c7578f69d04b278cd6458421e62d54 | nova        | compute        |
| c1f67723908b4190b648f452f049cc02 | glance      | image          |
| c3e6f0839bb84ea09d7f2005a98338c0 | cinderv2    | volumev2       |
| e3a78cf684404f839f1047dd267404fd | heat        | orchestration  |
| ef4ce71093324682adf7df09476cc06a | gnocchi     | metric         |
+----------------------------------+-------------+----------------+
```

## Orquestación de recursos 

Aparte de crear los recursos manualmente, también es posible utilizar unos *templates* que indican todos los recursos a utilizar en un despliegue determinado. De este modo se crean *stacks* que agrupan los recursos relacionados y permiten tratarlos como una unidad, tanto a la hora de crear como a la hora de limpiar el entorno. El componente que permite esto se llama *Heat* y se instala previamente como un servicio externo.

Para probarlo, primero se borran las instancias creadas previamente (usando el comando "openstack server"). Luego se crea el *stack*, lo cual dará un informe de estado preliminar y procederá a la instanciación de cada recurso.

```bash
./stack-create.sh
```

Una vez se ha desplegado, se puede comprobar el estado de cada *stack* que haya en la plataforma.

```bash
./stacks-list.sh
```

Así como consultar sus detalles concretos.

```bash
STACK_NAME="cirros-stack"
./stack-show.sh ${STACK_NAME}
```

Finalmente se procede al borrado del *stack*, que eliminará todos los recursos relacionados.

```bash
STACK_NAME="cirros-stack"
./stack-delete.sh ${STACK_NAME}
```

## Monitorización

OpenStack dispone de un sistema de telemetría que almacena una serie de métricas determinadas. Este componente se llama *Ceilometer* y mediante el mismo se puede obtener, por ejemplo, el consumo de CPU, memoria o la cantidad de datos recibidos o enviados desde cada *server*, entre muchas otras.

Inicialmente se puede observar la lista de métricas monitorizadas en este momento.

```bash
$ openstack metric list
+--------------------------------------+---------------------+--------------------------------------------+------+--------------------------------------+
| id                                   | archive_policy/name | name                                       | unit | resource_id                          |
+--------------------------------------+---------------------+--------------------------------------------+------+--------------------------------------+
| 238f3561-631e-4c1b-b1b7-e9274c905501 | ceilometer-low      | image.size                                 | B    | 41e5777e-18bc-4d0d-9048-660475b661a3 |
| 25b25bb9-d5b6-48f8-87f0-692656c13a2b | ceilometer-low      | disk.ephemeral.size                        | GB   | 9ee70716-110b-458b-9906-27f6e9c5016e |
| 2dae8abb-c657-48bc-ab74-ebb6da205c3d | ceilometer-low      | image.size                                 | B    | 742e1896-e959-4592-9e88-7ae6eabd4d1d |
| 309a8c48-d1b2-4780-aee2-ed1415e4340f | ceilometer-low      | compute.instance.booting.time              | sec  | 9ee70716-110b-458b-9906-27f6e9c5016e |
| 3a89e589-7bff-48af-9268-da9a02962435 | ceilometer-low      | image.size                                 | B    | 4457d2dc-42ea-48fd-a397-db81ede54425 |
| 4a1f5455-fe05-43d2-811c-bafd324fc12e | ceilometer-low      | volume.provider.pool.capacity.allocated    | GB   | ea9f9fcc-8003-52b1-af4d-4b29fbd9ed05 |
| 536b5d3e-9696-4fba-83b8-dee496000d5f | ceilometer-low      | volume.provider.pool.capacity.free         | GB   | ea9f9fcc-8003-52b1-af4d-4b29fbd9ed05 |
| 90feecc2-2113-4ce1-9e4b-530afc20b17d | ceilometer-low      | volume.provider.pool.capacity.total        | GB   | ea9f9fcc-8003-52b1-af4d-4b29fbd9ed05 |
| 949f8208-df16-4cfb-8040-3174fba53765 | ceilometer-low      | image.serve                                | B    | 41e5777e-18bc-4d0d-9048-660475b661a3 |
| 94f528f3-303f-464f-9bfb-ec5a64808d82 | ceilometer-low      | vcpus                                      | vcpu | 9ee70716-110b-458b-9906-27f6e9c5016e |
| 9b29a1c1-d6ca-4749-832a-c321eafa99cf | ceilometer-low      | memory.resident                            | MB   | 9ee70716-110b-458b-9906-27f6e9c5016e |
| ad4db06f-daea-49b9-bff2-6063cb7a8878 | ceilometer-low      | volume.provider.pool.capacity.virtual_free | GB   | ea9f9fcc-8003-52b1-af4d-4b29fbd9ed05 |
| b49dfb73-78ef-40aa-8d22-e776299d1264 | ceilometer-low      | volume.provider.pool.capacity.provisioned  | GB   | ea9f9fcc-8003-52b1-af4d-4b29fbd9ed05 |
| d106be17-dc46-4497-ae82-bf3ef914e7b5 | ceilometer-low      | cpu                                        | ns   | 9ee70716-110b-458b-9906-27f6e9c5016e |
| dccba4a8-e18a-4a5e-a44d-66497f193fe7 | ceilometer-low      | image.download                             | B    | 41e5777e-18bc-4d0d-9048-660475b661a3 |
| e48a429b-b954-45f7-b745-f41b775a011c | ceilometer-low      | disk.root.size                             | GB   | 9ee70716-110b-458b-9906-27f6e9c5016e |
| f6fcc261-2e0b-405a-874e-c7ee5c668aab | ceilometer-low      | memory                                     | MB   | 9ee70716-110b-458b-9906-27f6e9c5016e |
+--------------------------------------+---------------------+--------------------------------------------+------+--------------------------------------+
```

También se pueden obtener métricas concretas de cada recurso, de la forma:

```bash
$ openstack metric ${metric_name} ${resource_id}
```

En la documentación de OpenStack (https://docs.openstack.org/ceilometer/xena/admin/telemetry-measurements.html) se puede acceder a la lista completa de métricas según la versión.
