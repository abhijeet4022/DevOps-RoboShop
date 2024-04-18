# Variables inputs
parameters = {
  # DocumentDB
  "docdb.dev.master_username" = { type = "String", value = "docadmin" }

  # Aurora_MySQL
  "rds.dev.master_username" = { type = "String", value = "devadmin" }
  "rds.dev.database_name" = { type = "String", value = "dummy" }

  # DocumentDB
  "docdb.dev.master_password" = { type = "String", value = "roboshop1234" }

  # Aurora_MySQL
  "rds.dev.master_password" = { type = "String", value = "roboshop1234" }
}


#parameters = {
#  #For DocumentDB
#  "docdb.dev.master_username" = { type = "String", value = "docadmin" }
#  #For Aurora_MySQL
#  "rds.dev.master_username" = { type = "String", value = "devadmin" }
#  "rds.dev.database_name" = { type = "String", value = "dummy" }
#
#
#  "docdb.dev.master_password" = { type = "SecureString", value = "roboshop1234" }
#  "rds.dev.master_password" = { type = "SecureString", value = "roboshop1234" }
#}