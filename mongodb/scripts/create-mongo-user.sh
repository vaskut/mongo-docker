#!/bin/bash

echo "🧠 MongoDB User Creation (user stored in respective DB)"

read -p "🔹 Enter MongoDB container name: " CONTAINER
read -p "🔹 Enter target DB name (e.g., myappdb): " DB
read -p "🔹 Enter new username: " USER
read -s -p "🔹 Enter new password: " PASS
echo

ROOT_USER=$(docker exec "$CONTAINER" printenv MONGO_INITDB_ROOT_USERNAME)
ROOT_PASS=$(docker exec "$CONTAINER" printenv MONGO_INITDB_ROOT_PASSWORD)

if [[ -z "$ROOT_USER" || -z "$ROOT_PASS" ]]; then
  echo "❌ Could not fetch root credentials from container env."
  exit 1
fi

echo "✅ Creating user '$USER' inside DB '$DB'..."

docker exec -i "$CONTAINER" mongosh "$DB" -u "$ROOT_USER" -p "$ROOT_PASS" --authenticationDatabase "admin"   --quiet --eval "
db.createUser({
  user: '$USER',
  pwd: '$PASS',
  roles: [{ role: 'readWrite', db: '$DB' }]
});
"

echo "🎉 Done. User '$USER' created in DB '$DB'."
