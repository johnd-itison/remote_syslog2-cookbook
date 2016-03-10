# Overwrite this in your cookbook
default['remote_syslog2']['config'] = {
  files: [],
  exclude_files: [],
  exclude_patterns: [],
  hostname: node['hostname'],
  destination: {
    host: 'logs.papertrailapp.com',
    port: 12345
  }
}

case node['platform']
when 'ubuntu', 'debian'
  install_method = "deb"
else
  install_method = "source"
end

default['remote_syslog2']['install']['method'] = install_method

# The deb package uses a different and hardcoded config filename.
if install_method == "deb"
  default['remote_syslog2']['config_file'] = '/etc/log_files.yml'
else
  default['remote_syslog2']['config_file'] = '/etc/remote_syslog2.yml'
end

# These attributes probably shouldn't be changed unless they specifically need to be
default['remote_syslog2']['pid_dir'] = '/var/run'
default['remote_syslog2']['install']['version'] = '0.16'
default['remote_syslog2']['install']['download_tarball'] = "https://github.com/papertrail/remote_syslog2/releases/download/v#{node['remote_syslog2']['install']['version']}/remote_syslog_linux_386.tar.gz"
default['remote_syslog2']['install']['download_deb'] = "https://github.com/papertrail/remote_syslog2/releases/download/v#{node['remote_syslog2']['install']['version']}-beta-pkgs/remote-syslog2_#{node['remote_syslog2']['install']['version']}_i386.deb"
default['remote_syslog2']['install']['download_tarball_path'] = '/tmp/remote_syslog.tar.gz'
default['remote_syslog2']['install']['download_deb_path'] = '/tmp/remote_syslog2.deb'
default['remote_syslog2']['install']['extract_path'] = '/tmp'
default['remote_syslog2']['install']['extracted_path'] = '/tmp/remote_syslog'
default['remote_syslog2']['install']['extracted_bin'] = 'remote_syslog'
default['remote_syslog2']['install']['bin_path'] = '/usr/local/bin'
default['remote_syslog2']['install']['bin'] = 'remote_syslog2'
