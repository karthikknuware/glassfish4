#
# Cookbook Name:: glass
# Recipe:: default
#
# Copyright (C) 2016 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
bash 'install-glassfish' do
  code <<-EOH
sudo apt-get update
 EOH
end
package 'openjdk-7-jdk' do
  action :install
end
bash 'install-glassfish' do
  code <<-EOH
source /etc/environment
sudo apt-get install unzip
wget download.java.net/glassfish/4.0/release/glassfish-4.0.zip
unzip glassfish-4.0.zip -d /opt
 EOH
end
bash 'create-password' do
  code <<-EOH
  sudo touch password.txt
  sudo chmod 777 password.txt
  EOH
end  
bash "insert_line" do
  user "root"
  code <<-EOS
  echo "AS_ADMIN_PASSWORD=admin
        AS_ADMIN_ADMINPASSWORD=admin
        AS_ADMIN_USERPASSWORD=admin" >> /opt/glassfish4/bin/password.txt
  EOS
end  
bash 'install-glassfish' do
  code <<-EOH
  cd /opt/glassfish4/bin
   sudo ./asadmin --user admin --passwordfile password.txt  create-domain integ
   sudo ./asadmin --user admin --passwordfile password.txt  start-domain integ
   sudo ./asadmin --user admin --passwordfile password.txt  enable-secure-admin
   sudo ./asadmin --user admin --passwordfile password.txt  restart-domain integ
   sudo ./asadmin --user admin --passwordfile /opt/glassfish4/bin/password.txt  set configs.config.default-config.cdi-service.enable-implicit-cdi=false
   sudo ./asadmin --user admin --passwordfile /opt/glassfish4/bin/password.txt set configs.config.server-config.cdi-service.enable-implicit-cdi=false
   sudo ./asadmin --user admin --passwordfile /opt/glassfish4/bin/password.txt create-jvm-options --target default-config -- -Dcom.numi.java.app.env=testing
   sudo ./asadmin --user admin --passwordfile /opt/glassfish4/bin/password.txt create-jvm-options --target server-config -- -Dcom.numi.java.app.env=testing
    EOH
end
bash 'Setting up Postgres' do
  code <<-EOH
  cd /opt/glassfish4/glassfish/domains/integ/lib
  sudo wget https://jdbc.postgresql.org/download/postgresql-9.4.1208.jre7.jar
  sudo ./asadmin --user admin --passwordfile /opt/glassfish4/bin/password.txt create-jdbc-connection-pool --datasourceclassname org.postgresql.xa.PGXADataSource --restype javax.sql.XADataSource --property portNumber=5432:password=thisisareallylongpassword1:user=gfuser:serverName=diyapp-integ2.caibfusn2myj.us-east-1.rds.amazonaws.com:databaseName=diyapp appPool
  sudo ./asadmin --user admin --passwordfile /opt/glassfish4/bin/password.txt create-jdbc-connection-pool --datasourceclassname org.postgresql.xa.PGXADataSource --restype javax.sql.XADataSource --property portNumber=5444:password=thisisareallylongpassword1:user=gfuser:serverName=diyfdb-integ2.caibfusn2myj.us-east-1.rds.amazonaws.com:databaseName=diyfdb fdbPool
  sudo ./asadmin --user admin --passwordfile /opt/glassfish4/bin/password.txt create-jdbc-resource --connectionpoolid appPool jdbc/appPool
  
