# Mapanalyst.mzk.cz

Web service for map analysis. It is based on [MapAnalyst](http://mapanalyst.org/) software. The running instance listens on url http://mapanalyst.mzk.cz

## Requirements
* [Docker](https://www.docker.com/)

## Installation

On debian based systems you can create init script. Create file /etc/init.d/mapanalyst with following content

```
#!/bin/bash

### BEGIN INIT INFO
# Provides:          mapanalyst
# Required-Start:    docker
# Required-Stop:     docker
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Mapanalyst application
# Description:       Runs docker image.
### END INIT INFO

LOCK=/var/lock/mapanalyst
CONTAINER_NAME=mapanalyst
IMAGE_NAME=moravianlibrary/mapanalyst.mzk.cz

case "$1" in
  start)
    if [ -f $LOCK ]; then
      echo "Mapanalyst is running yet."
    else
      touch $LOCK
      echo "Starting mapanalyst.."
      docker run --name $CONTAINER_NAME -p 127.0.0.1:9001:8080 $IMAGE_NAME &
      echo "[OK] Mapanalyst is running."
    fi
    ;;
  stop)
    if [ -f $LOCK ]; then
      echo "Stopping mapanalyst.."
      rm $LOCK \
        && docker kill $CONTAINER_NAME \
        && docker rm $CONTAINER_NAME \
        && echo "[OK] Mapanalyst is stopped."
    else
      echo "Mapanalyst is not running."
    fi
    ;;
  restart)
    $0 stop
    $0 start
  ;;
  status)
    if [ -f $LOCK ]; then
      echo "Mapanalyst is running."
    else
      echo "Mapanalyst is not running."
    fi
  ;;
  update)
    docker pull $IMAGE_NAME
    $0 restart
  ;;
  *)
    echo "Usage: /etc/init.d/mapanalyst {start|stop|restart|status|update}"
    exit 1
    ;;
esac

exit 0
```

After it run these commands

```
# chmod 755 /etc/init.d/mapanalyst
# update-rc.d mapanalyst defaults
```

Now the mapanalyst service will be automatically start at server startup.

You can start service by

```
# /etc/init.d/mapanalyst start
```

The service listen on port 9001. Now you should install and setup apache http server, which will forward requests to docker container.

```
# apt-get update
# apt-get install apache2
```

In directory /etc/apache2/sites-available create file with name mapanalyst.mzk.cz and with content:

```
<VirtualHost *:80>
   ServerName mapanalyst.mzk.cz

   <IfModule mod_rewrite.c>
      RewriteEngine on
      Options +FollowSymlinks

      RewriteRule ^/(.+\.css)$  http://localhost:9001/MapAnalyst/$1 [P,L]
      RewriteRule ^/$  http://localhost:9001/MapAnalyst/Exporter [P,L]
   </IfModule>
</VirtualHost>
```

After it enable new settings and reload apache server.

```
# a2ensite mapanalyst.mzk.cz
# service apache2 reload
```
