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

* Consul: a tool for discovering and configuring services in your infrastructure.
> See: https://www.consul.io/

* Consul-template: a daemon used to populate values from Consul on your filesystem.
> See: https://github.com/hashicorp/consul-template

* Registrator: a tool that automatically register/deregister Docker containers into Consul.
> See: https://github.com/gliderlabs/registrator

* Dnsmasq: Lightweight DNS for small networks. 
> See: http://www.thekelleys.org.uk/dnsmasq/doc.html

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

## Retrieve Ops Manager parameters

Connect to http://localhost:8080 and create an account.

Next click on the GET STARTED button in the Automation box.

![Step1][opsmanager_step1]

Then, click on the BEGIN SETUP button.

![Step1][opsmanager_step2]

Choose Other Remote.

![Step1][opsmanager_step3]

Select a type of MongoDB deployment, we'll use a Sharded Cluster for the demo purpose.

![Step1][opsmanager_step4]

Specify details about your deployment, here we'll create a MongoDB cluster with 2 shards and 3 nodes per shard.

![Step1][opsmanager_step5]

Indicate your number of nodes, this will correspond to the number of mms-agent containers that we will need to start later.

![Step1][opsmanager_step6]

Choose an agent type (any type is fine, mms-agent uses Ubuntu 14.04 anyway).

![Step1][opsmanager_step7]

Now the more important step, retrieve the following parameters:

* MMS_GROUP_ID
* MMS_API_KEY
* BASE_URL

![Step1][opsmanager_step8]

We'll need these parameters to start the mms-agent containers.

Then click on the VERIFY AGENT button and continue to deploy your cluster.

## Add MMS agent nodes

When required, add MMS agent containers (replace the parameters with correct values):

```
$ docker run --rm \
  -e "SERVICE_NAME=mms-agent" \
  --dns $(docker inspect -f '{{.NetworkSettings.IPAddress}}' dockeropsmanager_dns_1) \
  -p 27000 \
  mms-agent \
  /opt/mongodb-mms-automation/bin/mongodb-mms-automation-agent -mmsBaseUrl=http://BASE_URL:8080 -mmsGroupId=MMS_GROUP_ID -mmsApiKey=MMS_API_KEY

```

[opsmanager_step1]: https://raw.githubusercontent.com/deviantony/docker-opsmanager/master/doc/img/step01.png "Ops Manager STEP 1"
[opsmanager_step2]: https://raw.githubusercontent.com/deviantony/docker-opsmanager/master/doc/img/step02.png "Ops Manager STEP 1"
[opsmanager_step3]: https://raw.githubusercontent.com/deviantony/docker-opsmanager/master/doc/img/step03.png "Ops Manager STEP 1"
[opsmanager_step4]: https://raw.githubusercontent.com/deviantony/docker-opsmanager/master/doc/img/step04.png "Ops Manager STEP 1"
[opsmanager_step5]: https://raw.githubusercontent.com/deviantony/docker-opsmanager/master/doc/img/step05.png "Ops Manager STEP 1"
[opsmanager_step6]: https://raw.githubusercontent.com/deviantony/docker-opsmanager/master/doc/img/step06.png "Ops Manager STEP 1"
[opsmanager_step7]: https://raw.githubusercontent.com/deviantony/docker-opsmanager/master/doc/img/step07.png "Ops Manager STEP 1"
[opsmanager_step8]: https://raw.githubusercontent.com/deviantony/docker-opsmanager/master/doc/img/step08.png "Ops Manager STEP 1"
