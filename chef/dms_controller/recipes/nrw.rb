#
# Cookbook Name:: dms_controller
# Recipe:: nrw
#
# Copyright (C) 2014 Epimorphics Ltd
#

prefix       = "#{node['dms_controller']['prefix']}"


node['dms_controller']['baseline'].each do |service, description|

    ['testing', 'production'].each do |envname|
        # Starting data images
        directory "/var/opt/dms/services/#{service}/publicationSets/#{envname}/images" do
            owner 'tomcat7'
            group 'tomcat7'
            mode 0755
            recursive true
        end

        description["#{envname}_baseline_images"].each do |img|
            bash "Install baseline image #{img} to #{envname}" do
                code <<-EOH
                cd /var/opt/dms/services/#{service}/publicationSets/#{envname}/images
                aws s3api get-object --bucket #{prefix}-dms-deploy --key baseline/#{img} #{img}
                chown tomcat7:tomcat7  #{img}
                chmod 0644  #{img}
                EOH
                not_if { File.exists?("/var/opt/dms/services/#{service}/publicationSets/#{envname}/images/#{img}") }
            end
        end

        # Starting web content
        directory "/var/opt/dms/services/#{service}/publicationSets/#{envname}/Web" do
            owner 'tomcat7'
            group 'tomcat7'
            mode 0755
            recursive true
        end

        img = description["#{envname}_web_snapshot"]
        bash "Fetch web content for #{envname}" do
            code <<-EOH
            cd #{node['epi_base']['deploy_files_dir']}
            aws s3api get-object --bucket #{prefix}-dms-deploy --key baseline/#{img} #{img}
            EOH
            not_if { File.exists?("#{node['epi_base']['deploy_files_dir']}/#{img}") }
        end

        bash "Install web content for #{envname}" do
            code <<-EOH
            cd /var/opt/dms/services/#{service}/publicationSets/#{envname}/Web
            tar zxf #{node['epi_base']['deploy_files_dir']}/#{img}
            chown -R tomcat7:tomcat7 .
            EOH
            not_if { File.exists?("/var/opt/dms/services/#{service}/publicationSets/#{envname}/Web/media") }
        end
    end
end

# Log consolidation support

package 'awstats'

user=node['dms_controller']['user'] 

## log-gen scripts themselves are part of lds-deploy install

cookbook_file "/etc/cron.d/log-gen" do
    source "log-gen.crontab"
    mode  0644
end

# Override apache config to include pubutil access
template "/etc/apache2/sites-available/dms.conf" do
    source 'apache.conf.erb'
    owner 'root'
    group 'root'
    mode  0644
    notifies :reload, "service[apache2]", :delayed
end
