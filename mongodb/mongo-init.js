db.createUser({
    user: "testUser",
    pwd: "password",
    roles: [{
        role: "readWrite",
        db: "test-database"
    }]
});