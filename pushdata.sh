#!/bin/bash

set -e 

if [ "$#" -ne 3 ]; then
  echo "Usage: ./push_data user_name input_data_file.csv table_name" >&2
  echo "For example: ./push_data maharishi building_permits.csv esha_m.building_permits" >&2
  exit 1
fi

DBHOST="dssgsummer2014postgres.c5faqozfo86k.us-west-2.rds.amazonaws.com"
DB="training_2015" 
DBUSER=$1
INPUT_DATA_FILE=$2
TABLE_NAME=$3

# formulate CREATE TABLE in SQL statement using csv file
#csvsql $INPUT_DATA_FILE > table.sql
# manually edit/verify CREATE TABLE statement
vim table.sql

CREATE_TABLE=$(cat table.sql)

RUN_ON_MYDB="psql -X -h $DBHOST -U $DBUSER -d $DB"

echo $RUN_ON_MYDB

# drop table if already exists
$RUN_ON_MYDB <<SQL 
drop table if exists $TABLE_NAME;
SQL


# run create table statement
$RUN_ON_MYDB -c "$CREATE_TABLE"

cat $INPUT_DATA_FILE | sed 's/\$//g' | sed 's/\ //g' | psql -h "$DBHOST" -U $DBUSER -d $DB -c "\COPY $TABLE_NAME FROM STDIN WITH CSV HEADER;" 
