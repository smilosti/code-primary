#!/bin/bash

# Define variables
DB_NAME="grc_ontology"
SCHEMA_FILE="/workspaces/code/services/typedb/grc_schema.tql"

# Function to check if the database exists
check_db_exists() {
  typedb console --core 0.0.0.0:1729 --command "database list" | grep -q $DB_NAME
}

# Create the database if it does not exist, otherwise prompt for update
if check_db_exists; then
  echo "Database $DB_NAME already exists."
  read -p "Press any key to update the schema or Ctrl+C to exit..."
else
  typedb console --core 0.0.0.0:1729 --command "database create $DB_NAME"
  if [ $? -ne 0 ]; then
    echo "Failed to create database $DB_NAME. Please check the server connection and try again."
    exit 1
  fi
fi

# Load the schema
typedb console --core 0.0.0.0:1729 <<EOF
transaction $DB_NAME schema write
source $SCHEMA_FILE
commit
EOF

if [ $? -ne 0 ]; then
  echo "Failed to load schema from $SCHEMA_FILE. Please check the file and try again."
  exit 1
else
  echo "Schema successfully loaded into $DB_NAME."
fi
