rm(list=ls())

library('RPostgreSQL')

drv <- dbDriver('PostgreSQL')
con <- dbConnect(drv, 
                 host = "dssgsummer2014postgres.c5faqozfo86k.us-west-2.rds.amazonaws.com",
                 dbname = "training_2015",
                 user = "ackermann",
                 password = "ackermann")

data <- dbGetQuery(con, "SELECT * FROM klaus_ackermann.building_violations_sample limit 1000;")

dbDisconnect(con)

head(data)
tail(data)

#remove column
data['SSA'] <- NULL

#remove all spaces in the namessum(is.na(data$VIOLATION.INSPECTOR.COMMENTS))
names(data) <- gsub(" ","_",names(data))

summary(data)


#find missing comments in VIOLATION_INSPECTOR_COMMENTS
sum(is.na(data$VIOLATION_INSPECTOR_COMMENTS) | data$VIOLATION_INSPECTOR_COMMENTS=='')
