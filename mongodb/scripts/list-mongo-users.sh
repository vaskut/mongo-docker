#!/bin/bash

echo "📋 MongoDB Users Across All Databases (Hybrid Mode)"

read -p "🔹 Enter MongoDB container name: " CONTAINER

ROOT_USER=$(docker exec "$CONTAINER" printenv MONGO_INITDB_ROOT_USERNAME)
ROOT_PASS=$(docker exec "$CONTAINER" printenv MONGO_INITDB_ROOT_PASSWORD)

if [[ -z "$ROOT_USER" || -z "$ROOT_PASS" ]]; then
  echo "❌ Could not fetch root credentials from container env."
  exit 1
fi

docker exec -i "$CONTAINER" mongosh admin -u "$ROOT_USER" -p "$ROOT_PASS" --quiet --eval '
const dbs = db.adminCommand("listDatabases").databases.map(d => d.name);

for (const dbName of dbs) {
  const ctx = db.getSiblingDB(dbName);
  try {
    const result = ctx.getUsers();
    const users = Array.isArray(result.users) ? result.users : result;

    if (!users || users.length === 0) {
      continue;
    }

    print(`\n📁 DB: ${dbName}`);
    for (const u of users) {
      const roleList = (u.roles || []).map(r => r.role + "@" + r.db).join(", ");
      print(`   👤 ${u.user} — Roles: ${roleList}`);
    }
  } catch (e) {
    print(`\n📁 DB: ${dbName}\n   ⚠️  Error fetching users: ${e.message}`);
  }
}
'
