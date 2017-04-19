# The prefix used to name this DMS instance
# Affects the naming of keys, S3 buckets, the control server
pre = 'nrw'
node.override['dms_controller']['prefix']         = pre

# The DNS name to use for the control server
node.override['dms_controller']['server_name']    = "#{pre}-controller.epimorphics.net"

# Set to true to enable TLS connections for the control server
node.override['dms_controller']['use_https']      = true

# The git repository containing the service configuration, scripts and UI templates
node.override['dms_controller']['conf_repo']     = "https://github.com/epimorphics/#{pre}-dms-deploy.git"

# Space separated list of names of elastic load balancers that should be monitored 
# by vacuumetrix and fed in to grpahite/carbon store
# This information won't be known until after a service has been deployed
node.override['dms_controller']['monitor_LBs']    = 'nrwbwq-producti-dataserv-LB nrwbwq-producti-presServ-LB'

# The grafana dashboards to install, each name should correspond to a file "grafana-dashboard-{name}.json"
node.override['dms_controller']['grafana_dashboards'] = ['dms', 'nrwbwq-production']

# Baseline data and media
node.override['dms_controller']['baseline']['nrwbwq']['testing_baseline_images']    = [ 'wales-baseline-2014-10-31.tgz', 'wales-baseline-2014-10-31.nq.gz' ]
node.override['dms_controller']['baseline']['nrwbwq']['testing_web_snapshot']       = 'wales-web-media-2014-10-27.tgz'
node.override['dms_controller']['baseline']['nrwbwq']['production_baseline_images'] = [ 'wales-baseline-2014-10-31.tgz', 'wales-baseline-2014-10-31.nq.gz'  ]
node.override['dms_controller']['baseline']['nrwbwq']['production_web_snapshot']    = 'wales-web-media-2014-10-27.tgz'

# Support for pubutil (AS out of hours)
node.override['dms_controller']['pubutil_war_base']  = 'http://repository.epimorphics.com/com/epimorphics/pubutil-nrw/1.0.0/'
node.override['dms_controller']['pubutil_war']       = 'pubutil-nrw-1.0.0.war'

node.override['epi_deploy']['pubutil']['repo']       = 'git@codebasehq.com:epimorphics/nrw/pubutil-deploy.git'
node.override['epi_deploy']['pubutil']['branch']     = 'master'
node.override['epi_deploy']['pubutil']['install_to'] = '/opt/pubutil'
node.override['epi_deploy']['pubutil']['user']       = 'tomcat7'
node.override['epi_deploy']['pubutil']['group']      = 'tomcat7'

# java 8
override['epi_java']['packages']            = [ 'openjdk-8-jre-headless' ]
override['epi_java']['java_home']           = '/usr/lib/jvm/java-8-openjdk-amd64'
override['epi_java']['default_alternative'] = "#{node['epi_java']['java_home']}/jre/bin/java"  
