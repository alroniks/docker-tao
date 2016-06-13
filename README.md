# Dockerized TAO

Docker container for running TAO Testing platform.

## Usage:

### apache

```
# run mysql container
docker run --name db -p "33060:3306" -e MYSQL_ROOT_PASSWORD=r00t -d mysql:latest

# run tao instance with linked mysql container
docker run --name tao --link db:mysql -p 8080:80 -d alroniks/tao:apache

# run tao instance with auto installation param
docker run --name tao --link db:mysql -p 8080:80 -e TAO_AUTOINSTALL=1 -e TAO_MODULE_URL=http://192.168.99.100:8080 -d alroniks/tao:apache

# get IP of virtual machine
docker-machine ip default

# open IP address in browser and run installation
open http://<your-machine-ip>:8080
```

### nginx

```
TBD
```

## Docker Compose Config

### apache

You can also add this config in file `docker-composer.yml` into folder `package-tao` and run `docker-compose up -d`. 

If you want automatically install application, add to environment section param `TAO_AUTOINSTALL: 1` and `TAO_MODULE_URL: http://192.168.99.100:8000` with correct IP and port.

```
version: '2'
services:
  db:
    image: mysql:latest
    ports:
      - 33060:3306
    environment:
      MYSQL_ROOT_PASSWORD: r00t
      MYSQL_USER: tao
      MYSQL_PASSWORD: tao
      MYSQL_DATABASE: tao
  tao:
    image: alroniks/tao:apache
    links:
      - db:mysql
    ports:
      - 8000:80
    volumes:
      - .:/var/www/html
    environment:
      TAO_DB_DRIVER: pdo_mysql
      TAO_DB_NAME: tao
      TAO_DB_USER: tao
      TAO_DB_PASSWORD: tao
      TAO_AUTOINSTALL: 1
      TAO_MODULE_URL: http://192.168.99.100:8000
```

### nginx

```
TBD
```

