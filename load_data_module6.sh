#!/bin/bash -x

RUN_ON_MYDB="psql92 -X -h dssgsummer2014postgres.c5faqozfo86k.us-west-2.rds.amazonaws.com -U ackermann -d training_2015"

csvsql-2.7 data/Building_Violations_sample_50000.csv > table.sql


#manuel edit table
vi table.sql


$RUN_ON_MYDB <<SQL
drop table if exists klaus_ackermann.building_violations_sample;
SQL

TABLE=$(cat table.sql)

$RUN_ON_MYDB -c "$TABLE"

cat data/Building_Violations_sample_50000.csv | sed 's/\$//g' | sed 's/\ //g' | psql92 -h dssgsummer2014postgres.c5faqozfo86k.us-west-2.rds.amazonaws.com -U ackermann -d training_2015 -c "\COPY klaus_ackermann.building_violations_sample FROM STDIN WITH CSV HEADER;" 






