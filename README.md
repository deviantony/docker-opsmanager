# docker-opsmanager

An attempt to use the MongoDB Ops Manager inside Docker.

# About

Powered by the following tools:

* Docker: a portable, lightweight runtime and packaging tool.
> See: https://www.docker.com/

* Docker-compose: a tool used to manage an application in distributed containers.
> See: https://docs.docker.com/compose/

* MongoDB Ops Manager: a service for managing, monitoring and backing up a MongoDB infrastructure.
> See: https://docs.opsmanager.mongodb.com/current/application/

# How-to

## Build the MMS agent image

```
$ docker build -t "mms-agent" agent/
```

## Start the stack

First, you'll need to update the file ops-manager/config/conf-mms.properties and change the *ROUTABLE_IP* with your IP address.

```
$ docker-compose build && docker-compose up
```

## Add MMS agent nodes

When required, add MMS agent containers (replace the parameters with correct values):

```
$ docker run --rm mms-agent /opt/mongodb-mms-automation/bin/mongodb-mms-automation-agent -mmsBaseUrl=http://OPS_MANAGER_IP:8080 -mmsGroupId=GROUP_ID -mmsApiKey=API_KEY
```
