# docker-tao

Docker container for run taotesting application

## Docker Compose Config

// apache
// nginx

```
web:
  image: tao
  links:
    - db:mysql
  ports:
    - 8080:80
  environment:
    TAO_DB_DRIVER: pdo_mysql
    TAO_DB_HOST: localhost
    TAO_DB_NAME: taoUnitTest
    TAO_DB_USER: myuser
    TAO_DB_PASSWORD: tao
    TAO_MODULE_NAMESPACE: http://sample/first.rdf
    TAO_MODULE_URL: http://myurl
    TAO_USER_LOGIN: admin
    TAO_USER_PASSWORD: admin
    TAO_EXTENSIONS: taoCe
db:
  image: mysql
  environment:
    MYSQL_ROOT_PASSWORD: example
  ports:
    - 3306:3306
```



