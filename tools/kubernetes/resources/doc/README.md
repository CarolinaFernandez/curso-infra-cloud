# Introducción a Kubernetes

En primer lugar se ha de acceder a $HOME/scripts.

```bash
cd ~/scripts
```

En este directorio se encuentra una serie de ejecutables con diferentes opciones a probar.

# Pasos iniciales

## Conocimiento del entorno

Antes de nada, este despliegue consta de un *cluster* con tres nodos:

- Plano de control: kubemaster (192.178.33.110)
- Plano de trabajo: kubenode01 (192.178.33.120), kubenode02 (192.178.33.130)

Cuando se accede a la VM por SSH se está en "kubemaster", pero es posible acceder a cualquier otro nodo mediante el script "connect" del entorno, como se indica en la raíz.

## Preparación de la GUI

Si se quiere operar con la interfaz gráfica se ha de abrir una nueva terminal en el nodo "kubemaster" y ejecutar el script adecuado.

```bash
./dashboard-enable.sh
```

En el script se indicará el enlace desde el cual la GUI (*dashboard*) se encuentra disponible desde el sistema base:

http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

Así como el *token* a introducir para poder autenticarse.

# Uso

## Información de sistema

Para empezar se puede echar un ojo a la versión de sistema.

```bash
kubectl version
```

Así como a los diferentes tipos de recursos, si se definen dentro de *namespaces* y en qué versión ofrece la API.

```bash
./api-resources.sh [--namespaced=true|false]
```

También se puede obtener la configuración de sistema.

```bash
./config-view.sh
```

## Obtener lista de *namespaces*

Los *namespaces* son espacios bajo los cuales se agrupan los diferentes recursos entre sí o se separan de otros.

```bash
./namespaces-list.sh
```

Aparte de consultar su lista completa, cuando se busca información sobre algún recurso puede ser necesario filtrar por *namespace*, en caso de que el recurso no se localice en el *namespace* por defecto ("default").

## Información de *cluster*

Se puede obtener información del estado del *cluster*, respecto a ciertos nodos o servicios.

```bash
./cluster-info.sh
```

O bien disponer de información detallada sobre el mismo.

```bash
kubectl cluster-info dump
```

Y también mostrar qué nodos conforman el *cluster*.

```bash
./cluster-nodes.sh
```

## Crear *pods*

Un *pod* es uno de los recursos ofrecidos por Kubernetes y la unidad mínima de despliegue. Contiene uno o más contenedores, y algunos datos extra.

En el primer ejemplo se procede a la creación de este recurso mediante un archivo YAML, el modo más común y completo para solicitar recursos en Kubernetes.

```bash
./pod-create.sh
```

Sin embargo, otro modo es desplegar el *pod* directamente.

```bash
kubectl run nginx --image=nginx
```

Se pueden consultar los detalles de cada *pod* u otro recurso. En este caso se miran los detalles del primero.

```bash
./pod-get.sh
```

O bien la lista completa de *pods*.

```bash
./pods-list.sh [-o wide]
```

O filtrando por alguna etiqueta (*label*), indicada durante la creación o modificación del recurso.

```bash
POD_LABEL="app=share-pod"
./pods-list-filter-label.sh $POD_LABEL
```

Se puede exponer el puerto en que corre el proceso del *pod*. En este caso se hará de forma que sólo se expone al nodo desde el que se ejecuta el comando. Para ello se puede utilizar *port forwarding*, de modo que se ejecuta un proceso que corre en primer plano y que expone el puerto del servicio en el *pod* al nodo en donde se ejecuta este *forwarding*.

```bash
./pod-port-forward.sh
```

En el mismo nodo en que se ejecuta dicho *forwarding* se puede utilizar un cliente como curl para comprobar el contenido expuesto por el proceso en el *pod*.

```bash
curl http://localhost:8082
```

Por otra parte, una acción muy común es acceder a la *shell* o terminal del contenedor que corre el *pod*.

```bash
./pod-attach.sh
```

Por último, se elimina uno de los pods.

```bash
kubectl delete pod nginx 
```

## Crear *serviceaccounts*

Un *serviceaccount* permite identificar a los procesos que corren dentro de cada contenedor en un *pod*. De este modo se identifican contra el *apiserver* de Kubernetes.

En este caso se crea un *serviceaccount* que se referencia desde un *clusterrolebinding*, ambos en un *namespace* determinado.

```bash
./serviceaccount-create.sh
```

Tras probar el ejemplo se puede eliminar.

```bash
./serviceaccount-delete.sh
```

## Crear *deployments*

Un *deployment* recoge la intención de un despliegue, una combinación de recursos de tipo *pod* o *replicasets*, así como información relacionada con los mismos.

Se procede primero a la creación de un *deployment* que despliega tres réplicas de *pods*.

```bash
./deployment-create.sh
```

Una vez invocado, se mira la lista de *deployments*.

```bash
./deployments-list.sh [-o wide]
```

O bien consultar los detalles del *deployment*.

```bash
./deployment-describe.sh
```

## Gestionar *replicasets*

Como parte del *deployment* anterior se generó un recurso de tipo *replicaset*, capaz de mantener el estado esperado en un conjunto de *pods*, acorde con unas indicaciones determinadas.

Inicialmente se investiga la lista de *replicasets* disponibles.

```bash
./replicasets-list.sh [-o wide]
```

Al igual que un *deployment*, un *replicaset* hace referencia a diferentes *pods*. Si se conoce el *label* usado por los *pods* se puede filtrar. En este ejemplo se pueden observar tres réplicas o *pods* como parte del despliegue anterior.

```bash
kubectl get pods -o wide --selector=app=nginx
```

En los *replicasets* existe la opción de escalar el número de réplicas según las necesidades de cada momento. En concreto, se puede escalar a un número superior de instancias (*scale up*) cuando el servicio ha de ofrecer mayor capacidad, y reducir el número de las instancias (*scale down*) cuando hay demasiado uso de recursos.

```bash
CURRENT_REPLICAS=3
TARGET_REPLICAS=2
./replicaset-scale.sh nginx-deployment $CURRENT_REPLICAS $TARGET_REPLICAS
```

En este caso se ha hecho un *scale down* de 3 réplicas iniciales a 2. Se puede observar cómo se eliminan los *pods* sobrantes mirando la lista de estos recursos.

```bash
./pods-list.sh
```

También se puede hacer un *scale up* y pasar de 2 a 5 réplicas.

```bash
CURRENT_REPLICAS=2
TARGET_REPLICAS=5
./replicaset-scale.sh nginx-deployment $CURRENT_REPLICAS $TARGET_REPLICAS
```

## Gestionar *horizontalpodautoscalers*

Otra manera de escalar es no haciéndolo al momento, sino definiendo una política. Esto se puede hacer con los *horizontalpodautoscalers*, definiendo un mínimo y máximo de réplicas esperadas, así como un consumo objetivo de CPU al que aspirar.

```bash
REPLICASET_NAME="nginx-deployment-66b6c48dd5"
MINIMUM_REPLICAS=3
MAXIMUM_REPLICAS=4
CPU_PERCENT=10
./horizontalpodautoscaler-scale.sh $REPLICASET_NAME $MINIMUM_REPLICAS $MAXIMUM_REPLICAS $CPU_PERCENT
```

Con esta política definida, se puede mostrar la lista de *pods* y ver su efecto.

```bash
./pods-list.sh
```

Para obtener los detalles básicos del *horizontalpodautoscaler* se puede mostrar su lista.

```bash
./horizontalpodautoscalers-list.sh
```

Y acceder a los detalles del recurso.

```bash
HPA_NAME="nginx-deployment-66b6c48dd5"
./horizontalpodautoscaler-describe.sh $HPA_NAME
```

Por último, se puede eliminar.

```bash
HPA_NAME="nginx-deployment-66b6c48dd5"
./horizontalpodautoscaler-delete.sh $HPA_NAME
```

Ahora que se ha terminado de demostrar el *deployment*, también se puede proceder a su borrado.

```bash
./deployment-delete.sh
```

## Gestionar *services*

Los *services* son una manera sencilla de agrupar una aplicación distribuida a lo largo de varios *pods* y de poder exponer sus recursos mediante IPs y DNS, la exposición de puertos que ofrecen servicio o el balanceo de carga.

En este caso se usará el *pod* creado anteriormente para demostrar el *service*. Un *pod* corre uno o más contenedores, cada uno con uno o más procesos expuestos en un puerto. Se puede exponer este puerto para hacerlo visible al nodo de Kubernetes. En este caso, se sabe que el proceso corre en el puerto 80 y se expone el mismo.

```bash
./pod-port-expose.sh
```

Esto crea un recurso de tipo *service*. Se pueden consultar sus detalles más importantes.

```bash
./service-get.sh [-o wide]
```

Una vez el puerto está expuesto se ha de revisar en qué nodo se instanció el *pod*, y luego consultar el puerto de dicho nodo se expone el proceso.

```bash
# Mirar la columna de "port(s)"
./service-get.sh [-o wide]

# Mirar la columna de "node"
kubectl get pod share-pod -o wide
```

Para comprobar el estado del proceso desde el nodo se pueden utilizar clientes como curl o un navegador usando la información obtenida arriba; esto es: la dirección del nodo de Kubernetes y el puerto en que se expone.

Finalmente se puede borrar el *pod* creado anteriormente.

```bash
./pod-delete.sh
```

Como el *service* es un recurso aparte asociado después, no se ha borrado. Se elimina manualmente.

```bash
./service-delete.sh
```

## Gestionar *configmaps*

Los *configmaps* permiten pasar información a diferentes recursos, en modo key/value. El objetivo de este recurso es el de agrupar configuraciones que se puedan reusar en diferentes recursos, desligándolos de los mismos.

En primer lugar se crea un *configmap*. Para este ejemplo se crea por la línea de comandos inicialmente, pasando ciertos valores de forma literal. Luego se actualiza el recurso con otros valores, y por último se crea un *pod* desde el cual se enlaza a este *configmap*.

```bash
./configmap-create.sh
```

Una vez creado, se puede observar la lista de *configmaps*.

```bash
./configmaps-list.sh
```

Así como los detalles del *configmap* concreto.

```bash
CONFIGMAP_NAME="redis-configmap"
./configmap-describe.sh $CONFIGMAP_NAME
```

Por último, se puede eliminar el recurso, junto con los otros asociados.

```bash
./configmap-delete.sh
```

## Gestionar *secrets*

Al igual que los *configmaps*, los *secrets* permiten agrupar información que sepuede usar en diferentes *pods*. En este caso concreto, se trata de información sensible que se ha de guardar con consideraciones especiales. A este respecto, estos datos se almacenan en Base64 y son accesibles en texto plano para quienes tengan acceso a la API.

Se proceder a crear dos tipos de *secret*, uno de tipo "Basic-Auth" y otro genérico.

```bash
./secret_basic_auth-create.sh
./secret_generic-create.sh
```

Una vez creado, se puede observar la lista de *secrets*.

```bash
./secrets-list.sh
```

Así como los detalles del *secret* concreto.

```bash
SECRET_NAME="secret-basic-auth"
./secret-describe.sh $SECRET_NAME
```

Entre los detalles que se pueden obtener están los propios datos sensibles que se almacenan en Base64. Como usuarios con acceso a la API, se pueden obtener y decodificar.

```bash
SECRET_NAME="secret-basic-auth"
./secret-describe_decode.sh $SECRET_NAME
```

Por último, se puede eliminar el recurso.

```bash
SECRET_NAME="secret-basic-auth"
./secret-delete.sh $SECRET_NAME

SECRET_NAME="opaque-secret"
./secret-delete.sh $SECRET_NAME
```

## Gestionar *jobs* y *cronjobs*

Tanto los *jobs* como los *cronjobs* son una especie de contenedores de tareas periódicas o recurrentes. Los *jobs* han de ser idempotentes y ser irrelevante cuántas veces se ejecuten sobre un mismo entorno, ya que un *cronjob* puede llegar a generar múltiples instancias de *jobs*.

Inicialmente se procede a crear un *cronjob*, que cada minuto imprime un mensaje.

```bash
./cronjob-create.sh
```

Se observa que en la lista de *cronjobs* se encuentra el nuevo creado, y que en la de *jobs* puede haber varios.

```bash
./cronjobs-list.sh
```

Para obtener detalles sobre cuántas veces se ha ejecutado el *cronjob*, se puede entrar a su detalle. Al final de la lista de detalles se indica el tiempo y la operación realizada, como en todo recurso.

```bash
CRONJOB_NAME="hello"
./cronjob-describe.sh $CRONJOB_NAME
```

Otra opción para monitorizar la ejecución de los *jobs* es usar el comando "watch", de modo que se pueden ver las nuevas invocaciones al momento.

```bash
./jobs-watch.sh
```

Finalmente se elimina el *cronjob*. Con éste se eliminarán también los demás *jobs* que se fueron creando para cumplir su cometido.

```bash
CRONJOB_NAME="hello"
./cronjob-delete.sh $CRONJOB_NAME
```

## Gestionar *resourcequotas*

Las *resourcequotas*, como su nombre indica, establecen cuotas para limitar el uso de recursos entre diferentes usuarios o equipos.

Primero se crea una *resourcequota*, que permite hasta la creación de tres *pods*, siempre que cumplan los requisitos indicados. Junto con ella se crea un recurso de tipo *priorityclass* y dos *pods*: uno que no entra dentro de la cuota y otro que sí.

```bash
./resourcequota-create.sh
```

Una vez creados los recursos, se puede mirar el detalle de la *resourcequota*.

```bash
./resourcequotas-list.sh
```

Y mirar el estado de los *pods*.

```bash
kubectl get pods
```

El primero no ha podido iniciarse por solicitar demasiada cuota de memoria. El segundo, sin embargo, entra dentro de los límites definidos.

Por último se elimina la *resourcequota*.

```bash
./resourcequota-delete.sh
```
