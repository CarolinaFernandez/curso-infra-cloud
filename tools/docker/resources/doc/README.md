# Introducción a Docker

En primer lugar se ha de acceder a $HOME/scripts.

```bash
cd ~/scripts
```

En este directorio se encuentra una serie de ejecutables con diferentes opciones a probar.

# Pasos iniciales

## Preparación de la GUI

Si se quiere operar con la interfaz gráfica se puede ejecutar el script con Portainer, que desplegará un contenedor al efecto.

```bash
./container-run_portainer.sh
```

En el script se indicará el enlace desde el cual la GUI se encuentra disponible desde el sistema base:

http://192.178.33.113:9000

El usuario y password se generan durante el primer acceso.

# Uso

## Información de sistema

Para empezar se puede echar un ojo a la versión de sistema.

```bash
docker version
```

También a información general del sistema.

```bash
docker system info
```

O bien investigar el espacio en disco ocupado por Docker.

```bash
docker system df
```

## Crear imágenes

Inicialmente se han de crear las imágenes que se van a utilizar para la creación de instancias.
En este caso se define una imagen mediante un Dockerfile, simplemente basándose en NGINX y cambiando el archivo expuesto por el servidor.

```bash
./image-build_nginx.sh
```

Se puede observar cómo se ha creado esta imagen en la lista.

```bash
./images-list.sh
```

E inspeccionar sus detalles. Se puede observar que la imagen tiene un nombre y un *label* para identificar la versión o tipo de la misma, por ejemplo.

```bash
IMAGE_NAME="nginx"
LABEL_NAME="local"
./image-inspect.sh $IMAGE_NAME $LABEL_NAME
```

Finalmente, si la imagen ya estuviese creada y almacenada en remoto (p.ej., DockerHub) se puede descargar directamente.

```bash
IMAGE_NAME="elasticsearch"
LABEL_NAME="7.8.0"
./image-pull.sh $IMAGE_NAME $LABEL_NAME
```

## Desplegar contenedores

Una vez se dispone de una imagen, se puede crear un contenedor.
Esto se puede hacer bien directamente desde la CLI, bien desde una imagen ya creada (con un archivo Dockerfile) o bien mediante docker-compose.

### Directamente mediante CLI

En este caso se expone el proceso del contenedor a un puerto accesible para la máquina en que corre Docker.

```bash
./container-run_nginx_port_local.sh
```

Se puede comprobar el servicio localmente en http://127.0.0.1:8080.

Una vez verificado, se puede eliminar.

```bash
CONTAINER_NAME="nginx_local"
./container-remove.sh $CONTAINER_NAME
```

Ahora se puede probar el despliegue de un contenedor cuyo puerto se expone también para otras máquinas.

```bash
./container-run_nginx_port_remote.sh
```

Ahora se puede comprobar el servicio desde la IP pública, en http://192.178.33.113:8080.

De nuevo se procede al borrado.

```bash
CONTAINER_NAME="nginx_local"
./container-remove.sh $CONTAINER_NAME
```

Y se verifica que estos contenedores de prueba ya no estén activos, mirando la lista de contenedores.

```bash
./containers-list.sh
```

### Desde una imagen ya creada

Otro modo de desplegar contenedores es desde una imagen creada anteriormente. En este caso se usa la imagen creada en los pasos anteriores, con un nombre y *tag* (o *label* o etiqueta) específicos.

```bash
./container-run_nginx_tagged.sh
```

Como en el último ejemplo, el proceso de este contenedor es accesible desde otras máquinas.

Ahora se puede eliminar la instancia de prueba.

```bash
CONTAINER_NAME="nginx_local"
./container-remove.sh $CONTAINER_NAME
```

También se puede eliminar la imagen creada previamente mediante el Dockerfile, y la imagen base que ésta usa.

```bash
IMAGE_NAME="nginx"
LABEL_NAME="local"
./image-delete.sh $IMAGE_NAME $LABEL_NAME
LABEL_NAME="stable"
./image-delete.sh $IMAGE_NAME $LABEL_NAME
```

Otro ejemplo que entra dentro de esta categoría demuestra también otra funcionalidad dentro del Dockerfile: la comprobación de la salud de un contenedor. En este ejemplo se crea una aplicación de Python corriendo en el servidor Flask, de modo que se expone un *endpoint* que devuelve ciertos datos. La idea de este comando es poder determinar que el proceso dentro de un contenedor corre con éxito.

```bash
./healthcheck-create.sh
```

El propio script genera un Dockerfile y otros archivos asociados para la prueba, así como esperar un número de segundos para dar tiempo a realizar estas comprobaciones.

El estado de salud del contenedor se puede comprobar de forma explícita, o bien desde la lista de contenedores.

```bash
# Opción 1
CONTAINER_NAME="flask-app"
docker inspect --format='{{json .State.Health}}' $CONTAINER_NAME
# Opción 2
docker ps -a
```

Una vez probado, se elimina este contenedor.

```bash
./healthcheck-delete.sh
```

### Mediante docker-compose

Una tercera manera de desplegar un contenedor es usando docker-compose, de forma que en un archivo especial se agrupan los diferentes contenedores que componen un servicio y se detalla la forma de desplegarlos dentro del archivo, en lugar de en la CLI; así como de indicar y comprobar las dependencias que pueda haber entre los mismos.

En el primer ejemplo se despliega el *stack* ELK (Elasticsearch, Logstash, Kibana), todo junto como un servicio.

```bash
./compose-up_elk.sh
```

Se puede observar la lista de *stacks* creados mediante docker-compose.

```bash
COMPOSE_PATH="elk_compose"
./compose-list.sh $COMPOSE_PATH
```

Y eliminarlo una vez se ha probado. Nota: esto se ha de ejecutar desde el mismo directorio en que se instanció, ya que es ahí donde tiene el contexto para entender qué recursos forman parte de un *stack* determinado.

```bash
COMPOSE_PATH="elk_compose"
./compose-down.sh $COMPOSE_PATH
```

En el segundo ejemplo de docker-compose se instancia una aplicación que corre mediante Django, así como una base de datos Postgres den que se insertan los datos generados en dicha aplicación.

```bash
./compose-up_django.sh
```

Mientras se despliega se solicita establecer un superusuario.
Una vez definido, se puede acceder con él a la aplicación desde la IP pública de la máquina: http://192.178.33.113:8000/admin

De nuevo, se puede eliminar el *stack* una vez probado.

```bash
COMPOSE_PATH="django_compose"
./compose-down.sh $COMPOSE_PATH
```

## Limpieza de sistema

Para asegurarse de que no quedan recursos que no están siendo usados y consumiendo espacio, se puede ejecutar lo siguiente.

```bash
./system-prune.sh
```

Sin embargo, esto no elimina los *volumes*, que habrán de ser eliminados manualmente.
