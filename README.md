# TAO Docker Image

Docker container for running TAO Testing platform.

## Summary

TAO image based on latest php-7 official image and uses latest build of code from [Official TAO Packages](http://www.taotesting.com/get-tao/official-tao-packages/), version 3.1 RC.

This container contains only php application, that runs on 9000 tcp port. For build full working application you should use Docker Compose configuration in folder `tao` in this repository.

## Usage

```
# clone repository
git clone https://github.com/Alroniks/docker-tao.git

# go to tao folder inside
cd docker-tao/tao

# compose installation
docker-compose up

# get IP of virtual machine
docker-machine ip default

# open IP address in browser and run installation
open http://<your-machine-ip>
```

**Note!** Mysql username and password stored in `tao/docker-compose.yml` config file. 

**Note!** Mysql host during the installation should be defined as `db:mysql`.