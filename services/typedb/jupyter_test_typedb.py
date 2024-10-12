# Import libraries
import pandas as pd
from typedb.driver import TypeDB, SessionType, TransactionType
import torch

print("Imports successful.")

# Connect to TypeDB
try:
    with TypeDB.core_driver("localhost:1729") as driver:
        # Create a new database
        try:
            if not driver.databases().contains("test_db"):
                driver.databases().create("test_db")
                print("Database 'test_db' created successfully.")
            else:
                print("Database 'test_db' already exists.")
        except Exception as e:
            print(f"Error creating database: {e}")

        # Open a session to the new database
        with driver.session("test_db", SessionType.DATA) as session:
            # Start a transaction
            with session.transaction(TransactionType.WRITE) as transaction:
                # Insert a simple entity
                query = 'insert $x isa person, has name "John Doe";'
                transaction.query().insert(query)
                transaction.commit()
                print("Inserted entity into 'test_db'.")

            # Read the entity back
            with session.transaction(TransactionType.READ) as transaction:
                query = 'match $x isa person, has name $n; get $n;'
                iterator = transaction.query().match(query)
                for answer in iterator:
                    print("Retrieved entity with name:", answer.get("n").get_value())

        # Delete the test database
        try:
            driver.databases().get("test_db").delete()
            print("Database 'test_db' deleted successfully.")
        except Exception as e:
            print(f"Error deleting database: {e}")

except Exception as e:
    print(f"Error: {e}")

