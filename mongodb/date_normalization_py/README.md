### Script for date normalization

This is date normalization script for MongoDB.
It takes database name, collection name and field name which keep any datetime string.
Then, in this case, it checks if hour in this certain field  of each document in collection greater than 18 (you should change it for yours migration script) then increase that day by one.
Then, it set each 'time' in this certain field  of each document in collection to midnight (00:00:00)

This script very useful for people's birthdays which have been placed in db with wrong time, timezone or time of the day.

#### Usage  
* dn2 - for Python2
* dn3 - for Python3

```
dn [options]

Options:
  -h, --help          Show help message and exit
  -u MONGO_URI        MongoDB uri string (default: mongodb://localhost:27017/)
  -a ADDRESS          Mongo server address (default: localhost)
  -p PORT             Mongo server port (default: 27017)
  -d DATABASE_NAME    Database name
  -c COLLECTION_NAME  Collection name
  -f FIELD_NAME       Field name
  --debug=DNUM        DEBUG: Print debug functiion:
                      1 - Print all dates in iso date format
                      2 - Print all dates in mongo date format
                      3 - Print normalized dates in iso date format
                      Default: run date normalization
```
