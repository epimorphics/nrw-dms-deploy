#
# Cookbook Name:: dms_controller
# Recipe:: pubutil_war
#
# Copyright (C) 2014 Epimorphics Ltd
#

war_base = node['dms_controller']['pubutil_war_base']
war      = node['dms_controller']['pubutil_war']
war_file = "#{node['epi_base']['deploy_files_dir']}/#{war}"

bash "Clean any bad download of pubutil war" do
    code "rm #{war_file}"
    only_if { File.zero?(war_file) }
end

remote_file war_file do
    source "#{war_base}/#{war}"
    action :create_if_missing
end

tomcat_user = node['epi_tomcat']['user_name']

bash "Install pubutil war" do
    code <<-EOH
        rm -rf #{node['dms_controller']['webapps']}/pubutil
        cp #{war_file} #{node['dms_controller']['webapps']}/pubutil.war
    EOH
    notifies :restart, "service[tomcat7]", :delayed
end
