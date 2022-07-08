# Connection String format
"mongodb://test:testpwd@localhost/test?authSource=admin"
Example:
mongodb://testUser:password@localhost:27017/test-database?authSource=test-database

# Connect to mongo shell over Docker container
docker ps [Get container id XXXX]
docker exec -it [XXXX] /bin/sh
mongo -u admin -p password

# Create database
use [db-name]

# Create user
db.createUser(
{	user: "user",
	pwd: "password",

	roles:[{role: "readWrite" , db:"db-name"}]
})

