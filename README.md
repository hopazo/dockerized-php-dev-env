##Dockerized PHP dev ENV

Container docker con entorno de desarrollo para PHP

### Prerequisitos
Docker. Ha sido probado en Docker sobre ubuntu 16.04 y Docker para mac
Para instalar en Ubuntu:

```
sudo apt install docker-engine
```

### Construcción de la imagen

Navegar hasta el directorio donde se encuentra el archivo Dockerfile.
Construir una imagen de docker a partir del archivo, asignando un nombre de repositorio (ej: backend-dev) y tag: (ej: v1) con:

```
docker build -t <repositorio>:<tag> .
```

### Uso

Para iniciar un container 

```
docker run -it -p <IP_HOST>:<PUERTO_HOST>:<PUERTO_CONTAINER> -v /ruta/host:/ruta/container --name=<NOMBRE_CONTAINER> -d <repositorio>:<tag>
```

Conectar una shell al container

```
docker exec -it <NOMBRE_CONTAINER> bash
```
