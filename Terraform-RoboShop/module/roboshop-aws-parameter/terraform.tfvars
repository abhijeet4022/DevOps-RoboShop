# Variables inputs
parameters = {


  # DocumentDB
  "docdb.dev.master_username" = { type = "String", value = "docadmin" }
  "docdb.dev.endpoint"        = {
    type = "String", value = "dev-docdb-cluster.cluster-c90w68i6u5b5.us-east-1.docdb.amazonaws.com"
  }

  # Redis
  "user.dev.REDIS_HOST" = {
    type = "String", value = "dev-redis-elasticache-cluster.7lakuq.0001.use1.cache.amazonaws.com"
  }

  # Cart
  "cart.dev.REDIS_HOST" = {
    type = "String", value = "dev-redis-elasticache-cluster.7lakuq.0001.use1.cache.amazonaws.com"
  }
  "cart.dev.CATALOGUE_HOST" = { type = "String", value = "catalogue-dev.learntechnology.cloud" }
  "cart.dev.CATALOGUE_PORT" = { type = "String", value = 80 }


  # Shipping
  "shipping.dev.CART_ENDPOINT" = { type = "String", value = "cart-dev.learntechnology.cloud:80" }
  "shipping.dev.DB_HOST"       = {
    type = "String", value = "dev-aurora-mysql-rds-cluster.cluster-c90w68i6u5b5.us-east-1.rds.amazonaws.com"
  }


  # Payment
  "payment.dev.CART_HOST" = { type = "String", value = "cart-dev.learntechnology.cloud" }
  "payment.dev.CART_PORT" = { type = "String", value = 80 }
  "payment.dev.USER_HOST" = { type = "String", value = "user-dev.learntechnology.cloud" }
  "payment.dev.USER_PORT" = { type = "String", value = 80 }
  "payment.dev.AMQP_HOST" = { type = "String", value = "rabbitmq-dev.learntechnology.cloud" }

  #RabbitMQ
  "rabbitmq.dev.AMQP_USER" = { type = "String", value = "roboshop" }
  "rabbitmq.dev.AMQP_PASS" = { type = "String", value = "roboshop123" }

  # Dispatch
  "dispatch.dev.AMQP_HOST" = { type = "String", value = "rabbitmq-dev.learntechnology.cloud" }




  # Aurora_MySQL
  "rds.dev.master_username" = { type = "String", value = "devadmin" }
  "rds.dev.database_name"   = { type = "String", value = "dummy" }

  # DocumentDB
  "docdb.dev.master_password" = { type = "SecureString", value = "roboshop1234" }

  # Aurora_MySQL
  "rds.dev.master_password" = { type = "SecureString", value = "roboshop1234" }

  #ElasticSearch
  "elasticsearch.username" = { type = "String", value = "elastic" }
  "elasticsearch.password" = { type = "SecureString", value = "wXUu_puopW+I=3L8fW_T" }

  #SonarQube
  "sonarqube.username" = { type = "String", value = "admin" }
  "sonarqube.password" = { type = "SecureString", value = "DevOps321" }

  #Nexus for jenkins
  "nexus.username" = { type = "String", value = "admin" }
  "nexus.password" = { type = "SecureString", value = "DevOps321" }



  ##AppVersion
  "frontend.dev.appVersion"  = { type = "String", value = "1.0.0" }
  "catalogue.dev.appVersion" = { type = "String", value = "1.0.0" }
  "user.dev.appVersion"      = { type = "String", value = "1.0.0" }
  "cart.dev.appVersion"      = { type = "String", value = "1.0.0" }
  "shipping.dev.appVersion"  = { type = "String", value = "1.0.0" }
  "payment.dev.appVersion"   = { type = "String", value = "1.0.0" }


}
