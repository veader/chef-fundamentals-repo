#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "httpd" do
  action :install
end

service "httpd" do
  action [ :enable, :start ]
end

ruby_block "randomly_choose_language" do
  # run this block at execute time not compile time
  block do
    node.run_state["scripting_language"] = Random.rand > 0.5 ? "php" : "perl"
  end
end

package "scripting_language" do
  # use lazy to delay this to the execute phase
  package_name lazy { node.run_state["scripting_language"] }
  action :install
end

# Disable the default virtual host
execute "mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf.disabled" do
  only_if do
    File.exist?("/etc/httpd/conf.d/welcome.conf")
  end
  notifies :restart, "service[httpd]"
end

# Iterate over the apache sites
node["apache"]["sites"].each do |site_name, site_data|
  apache_vhost site_name do
    site_port site_data["port"]
    action :create
    notifies :restart, "service[httpd]"
  end
end
