oliverwehn-docker-mongodb
=========================

Base docker image to run a MongoDB database server with preset database, username and password of your choice.
Based on [tutum/mongodb](https://github.com/tutumcloud/tutum-docker-mongodb) image.


MongoDB version
---------------

Different versions are built from different folders. If you want to use MongoDB, please check the image’s repository: https://github.com/oliverwehn/oliverwehn-docker-mongodb


Usage
-----

To create the image `oliverwehn/mongodb`, execute the following command on the tutum-mongodb folder:

```shell
docker build -t oliverwehn/mongodb 3.0/ .
```




Running the MongoDB server
--------------------------

Run the following command to start MongoDB:
```shell
docker run -d -p 27017:27017 -p 28017:28017
```
or
```shell
docker run -d -p 27017:27017 -p 28017:28017 \
-e MONGODB_ADMIN_PASS='youradminpass' \
-e MONGODB_USER_NAME='yourusername' \
-e MONGODB_USER_PASS='youruserpassword' \
-e MONGODB_USER_DB='youruserdb' \
oliverwehn/mongodb
```

If one of the MONGODB_* environment variables isn’t set, it’s default values apply:
* MONGODB_ADMIN_PASS: random password
* MONGODB_USER_NAME: 'app_user'
* MONGODB_USER_PASS: random password
* MONGODB_USER_DB: 'app'

To get the random passwords, check the logs of the container after first run using:

```shell
docker logs <CONTAINER_ID>
```

You will see an output like the following:

        ========================================================================
        You can now connect to this MongoDB server using:

            mongo admin -u admin -p '5elsT6KtjrqV' --host <host> --port <port>
            Please remember to change the above password as soon as possible!

            mongo app -u app_user -p 'Hzdf7a8Z' --host <host> --port <port>
            Please remember to change the above password as soon as possible!

        ========================================================================

In this case, `5elsT6KtjrqV` is the password set for admin, `Hzdf7a8Z` the one for
user `app_user` on database `app`.

You can then connect to MongoDB:
```shell
mongo admin -u admin -p 5elsT6KtjrqV
```
or
```shell
mongo app -u app_user -p Hzdf7a8Z
```

Done!


Run MongoDB without password
----------------------------

If you want to run MongoDB without password you can set the environment variable `AUTH` to specific if you want password or not when running the container:

        docker run -d -p 27017:27017 -p 28017:28017 -e AUTH=no oliverwehn/mongodb

By default is "yes".


Run MongoDB with a specific storage engine
------------------------------------------

In MongoDB 3.0 there is a new environment variable `STORAGE_ENGINE` to specific the mongod storage driver:

        docker run -d -p 27017:27017 -p 28017:28017 -e AUTH=no -e STORAGE_ENGINE=mmapv1 oliverwehn/mongodb:3.0

By default is "wiredTiger".


Change the default oplog size
-----------------------------

In MongoDB 3.0 the variable `OPLOG_SIZE` can be used to specify the mongod oplog size in megabytes:

        docker run -d -p 27017:27017 -p 28017:28017 -e AUTH=no -e OPLOG_SIZE=50 oliverwehn/mongodb:3.0

By default MongoDB allocates 5% of the available free disk space, but will always allocate at least 1 gigabyte and never more than 50 gigabytes.


**based on tutum-docker-mongodb image by http://www.tutum.co**
**customized by http://www.oliverwehn.com**
