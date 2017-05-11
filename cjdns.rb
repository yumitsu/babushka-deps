dep 'cjdns' do
  requires_when_unmet 'cjdns.src'
  met? {
    !which('cjdroute').nil?
  }
end

dep 'cjdns.src', :cjdns_bin_path, :cjdns_config_path do
  cjdns_bin_path.default! '/usr/bin'
  cjdns_config_path.default! '/etc'

  requires_when_unmet 'python.bin', 'yumitsu:nodejs.bin', 'unzip.bin'

  source 'https://github.com/cjdelisle/cjdns/archive/master.zip'

  provides 'cjdroute'

  configure {
    true
  }
  build {
    log_shell "build", "./do"
  }
  install {
    log_shell "generating config", "./cjdroute --genconf > cjdroute.conf"
    log_shell "copy binary to #{cjdns_bin_path}", "cp ./cjdroute #{cjdns_bin_path / 'cjdroute'}"
    log_shell "moving config to #{cjdns_config_path}", "mv ./cjdroute.conf #{cjdns_config_path / 'cjdroute.conf'}"
  }
  postinstall {
    unless which('systemctl').nil?
      log_shell "installing systemd service", "cp ./contrib/systemd/*.service /etc/systemd/system/"
      log_shell "enabling systemd service", "systemctl enable cjdns"
    end
  }
end

dep 'unzip.bin'
