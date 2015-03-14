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

## Deploy a sharded cluster

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

Choose an agent type (any type is fine, the mms-agent image uses Ubuntu 14.04 anyway).

![Step1][opsmanager_step7]

Retrieve the following parameters:

* MMS_GROUP_ID
* MMS_API_KEY
* BASE_URL

![Step1][opsmanager_step8]

We'll need these parameters to start the mms-agent containers.

Now is the time to start these containers (replace the *BASE_URL*, *MMS_GROUP_ID* and *MMS_API_KEY* parameters with the values you retrieved previously):

```
$ docker run --rm \
  -e "SERVICE_NAME=mms-agent" \
  --dns $(docker inspect -f '{{.NetworkSettings.IPAddress}}' dockeropsmanager_dns_1) \
  -p 27000 \
  mms-agent \
  /opt/mongodb-mms-automation/bin/mongodb-mms-automation-agent -mmsBaseUrl=BASE_URL -mmsGroupId=MMS_GROUP_ID -mmsApiKey=MMS_API_KEY

```

Once you have started the appropriate number of containers, return to the Ops Manager and click on the VERIFY AGENT button. 

If everything is ok you'll be able to continue your deployment.

[opsmanager_step1]: https://cloud.githubusercontent.com/assets/5485061/6651719/e80c6c92-ca51-11e4-8f13-9acc7c0dee2f.png "Ops Manager STEP 1"
[opsmanager_step2]: https://cloud.githubusercontent.com/assets/5485061/6651720/ea84f78c-ca51-11e4-8ca5-c60d268d252a.png "Ops Manager STEP 2"
[opsmanager_step3]: https://cloud.githubusercontent.com/assets/5485061/6651721/ec6f9746-ca51-11e4-97e6-c503212f30e5.png "Ops Manager STEP 3"
[opsmanager_step4]: https://cloud.githubusercontent.com/assets/5485061/6651722/efee61a4-ca51-11e4-8f07-7a35facab0d7.png "Ops Manager STEP 4"
[opsmanager_step5]: https://cloud.githubusercontent.com/assets/5485061/6651723/f15493ba-ca51-11e4-85b5-75fdefaca01e.png "Ops Manager STEP 5"
[opsmanager_step6]: https://cloud.githubusercontent.com/assets/5485061/6651724/f3ebd020-ca51-11e4-80b6-aa63a91efcf7.png "Ops Manager STEP 6"
[opsmanager_step7]: https://cloud.githubusercontent.com/assets/5485061/6651725/f5b639c2-ca51-11e4-82cc-5958dea9fa97.png "Ops Manager STEP 7"
[opsmanager_step8]: https://cloud.githubusercontent.com/assets/5485061/6651746/4be248a8-ca53-11e4-8637-b0391302ac6c.png "Ops Manager STEP 8"

