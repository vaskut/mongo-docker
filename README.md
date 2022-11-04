# Connection String format
"mongodb://test:testpwd@localhost/test?authSource=admin"

Example: 
mongodb://testUser:password@localhost:27017/test-database?authSource=test-database

# Connect to mongo shell over Docker container
docker ps [Get container id XXXX] 
docker exec -it [XXXX] /bin/sh  
mongo -u admin -p password 
mongo "[URI]"

# Useful commands
show dbs //Show all databases 
use [db-name] //Create switch database


# Create new user
```sh
db.createUser(
{	user: "user",
	pwd: "password",

	roles:[{role: "readWrite" , db:"db-name"}]
})
```

# How to run Mongo in RS mode

1. Uncomment command, extra_hosts, keyfile lines in docker-compose.yml 
2. Run `openssl rand -base64 768 > keyfile.txt` to generate security keyfile
3. Run docker-compose up -d as usual
4. In hosts's etc/hosts file, add a 127.0.0.1 for the mongo hostname, ex: my-host.my-mongo.com
5. Connect with mongo docker using docker exec
6. Login to mongosh using admin username/password
7. Run rs.initiate with config (change as applicable):
```sh
rs.initiate({
    "_id" : "replicaSet001",
    "version" : 1,
    "term" : 1,
    "members" : [
            {
                    "_id" : 0,
                    "host" : "my-host.my-mongo.com:27017",
                    "arbiterOnly" : false,
                    "buildIndexes" : true,
                    "hidden" : false,
                    "priority" : 1,
                    "tags" : {

                    },
                    "secondaryDelaySecs" : NumberLong(0),
                    "votes" : 1
            }]
});
```

# PS
Unless RS is initialized, docker logs should show this
```sh
{"t":{"$date":"2022-11-04T07:02:25.001+00:00"},"s":"I",  "c":"-",        "id":4939300, "ctx":"monitoring-keys-for-HMAC","msg":"Failed to refresh key cache","attr":{"error":"NotYetInitialized: Cannot use non-local read concern until replica set is finished initializing.","nextWakeupMillis":6800}}
```