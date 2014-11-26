dep 'etcd', :version, :patchlevel, :prefix do
    version.default! '0.5.0'
    patchlevel.default! 'alpha.3'
    prefix.default!(shell('whoami') == 'root' ? '/usr/bin' : '~/bin')

    def version_group
        "#{version}-#{patchlevel}"
    end

    def osdep_group
        "#{Babushka.host.linux? ? 'linux' : 'darwin'}-amd64"
    end

    def source_uri
        "https://github.com/coreos/etcd/releases/download/v#{version_group}/etcd-v#{version_group}-#{osdep_group}.tar.gz"
    end

    def binaries
        ['etcd', 'etcdctl', 'etcd-migrate']
    end

    def binaries_presents?
        binaries.select{|binary| File.exist?(prefix / binary) and File.executable?(prefix / binary)}.size == 3
    end

    met? {
        in_path? 'etcd' and binaries_presents? and prefix.exist? and prefix.writeable?
    }

    meet {
        Babushka::Resource.extract source_uri do |path|
            binaries.each{|binary| 
                shell "cp #{binary} #{prefix}"
            }
        end

        log_ok "binaries copied to #{prefix}"
    }
end
