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
sudo apt-get install python-software-properties
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo wget --no-cookies --no-check-certificate --header “Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie” “https://download.oracle.com/otn-pub/java/jdk/8u51-b16/jdk-8u51-linux-x64.rpm"
sudo rpm -ivh jdk-8u51-linux-x64.rpm
 EOH
end
bash "insert_line" do
  user "root"
  code <<-EOS
  echo "JAVA_HOME="/usr/lib/jvm/java-8-oracle"" >> /etc/environment
  EOS
  #not_if "grep -q JAVA_HOME= "/usr/lib/jvm/java-8-oracle" /etc/environment"
end
bash 'install-glassfish' do
  code <<-EOH
source /etc/environment
sudo apt-get install unzip
wget download.java.net/glassfish/4.0/release/glassfish-4.0.zip
unzip glassfish-4.0.zip -d /opt
 EOH
end

