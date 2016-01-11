install = node['remote_syslog2']['install']
bin_file = "#{install['bin_path']}/#{install['bin']}"

if install['method'] == "source"

  remote_file install['download_tarball_path'] do
    source install['download_tarball']
    mode '0644'
    not_if { ::File.exists?(bin_file) }
  end

  bash 'extract remote_syslog2' do
    cwd '/tmp'
    code <<-EOH
    mkdir -p #{install['extracted_path']}
    tar xzf #{install['download_tarball_path']} -C #{install['extract_path']}
    mv #{install['extracted_path']}/#{install['extracted_bin']} #{bin_file}
    rm -rf #{install['download_tarball_path']} #{install['extracted_path']}
    EOH
    not_if { ::File.exists?(bin_file) }
  end

  file bin_file do
    user 'root'
    group 'root'
    mode 0755
  end
elsif install['method'] == "deb"
  dpkg_package "remote_syslog2" do
    action :nothing
    source install['download_deb_path']
  end

  remote_file install['download_deb_path'] do
    source install['download_deb']
    mode '0644'
    # This looks messy, but it's just checking that the installed version (if any) isn't the
    # same as the version we want to install. This allows us to do upgrades just by changing
    # an attribute.
    not_if "test `dpkg-query -W --showformat='${Version}' remote-syslog2:i386` = #{install['version']}"
    notifies :install, "dpkg_package[remote_syslog2]", :immediately
  end


  # Remove legacy binary if previously installed using 'source' method.

  file bin_file do
    action :delete
    only_if { ::File.exists?(bin_file) }
  end
end
