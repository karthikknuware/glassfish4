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

