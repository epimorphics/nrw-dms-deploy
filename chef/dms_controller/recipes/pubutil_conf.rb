#
# Cookbook Name:: dms_controller
# Recipe:: pubutil_conf
#
# Copyright (C) 2014 Epimorphics Ltd
#

tomcat_user = node['epi_tomcat']['user_name']

# Install the configuration files
include_recipe 'epi_deploy'

# Install the credetials from the data bags
credentials = Chef::EncryptedDataBagItem.load( 'pubutil', "credentials" )

template "/opt/pubutil/scripts/credentials" do
  source 'credentials.erb'
  owner 'root'
  group 'root'
  mode   0644
  variables( { dms_user_credentials: credentials['suspensionsuser'] } )
end  

template "/opt/pubutil/scripts/fcredentials" do
  source 'credentials.erb'
  owner 'root'
  group 'root'
  mode   0644
  variables( { dms_user_credentials: credentials['forecastuser'] } )
end  

# Create working area
directory "/mnt/disk1/var/opt/pubutil" do
    owner tomcat_user
    group tomcat_user
    mode  0755    
    recursive true
end

link "/var/opt/pubutil" do
    to   "/mnt/disk1/var/opt/pubutil"
end
