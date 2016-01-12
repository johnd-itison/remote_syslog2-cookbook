if node['install']['method'] == "source"
  template '/etc/init.d/remote_syslog2' do
    source 'remote_syslog2.erb'
    mode '0755'
  end
else
  # Clean up old 'source'/'tarball' type installations.
  file "/etc/init.d/remote_syslog2" do
    action :delete
    only_if { ::File.exists?("/etc/init.d/remote_syslog2" }
  end
end

service 'remote_syslog' do
  supports restart: true, status: true
  action [:start, :enable]
end
