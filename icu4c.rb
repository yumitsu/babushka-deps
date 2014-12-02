

dep 'homebrew', :template => 'core:bin' do
    installs []
    provides 'brew'
    
    met? {
        unmeetable! "Run `babushka 'core:homebrew'` explicitly from terminal." if not in_path?(provides)
        true
    }
end

dep 'xcode tools' do
    met? {
        in_path? ['cc', 'c++', 'clang', 'ld', 'libtool', 'gcc', 'g++', 'make']
    }
end

meta :bopt do
    accepts_list_for :provides, []
    accepts_value_for :package, :basename, :choose_with => :via
    accepts_list_for :depends_on, [], :choose_with => :via
    
    def prefix
        shell "brew --prefix #{basename}"
    end
    
    def bin_dir
        (prefix / 'bin')
    end
    
    def sbin_dir
        (prefix / 'sbin')
    end
    
    def provides?
        if provides.is_a?(String)
            return (bin_dir / provides).p.exists?
        elsif provides.is_a?(Array)
            return true if provides.size.zero?
            
            provides.each do |bin|
                check = (bin_dir / bin).p.exists? || (sbin_dir / bin).p.exists?
                return false if !check
            end
            
            true
        end
    end
    
    def pkg_install!
        Babushka.host.pkg_helper.handle_install! package
    end
    
    def has_pkg?
        Babushka.host.pkg_helper.has? package rescue false
    end
    
    def dependants_fulfilled?
        depends_on.all? {|pkg|
            Babushka.host.pkg_helper.has? pkg
        }
    end
    
    template {
        met? {
            prefix.p.exists?.tap {|r|
                log "path exists?: #{r}"
            } and provides?.tap {|r| 
                log "provide files?: #{r}"
            } and has_pkg?.tap {|r|
                log "brew pkg installed?: #{r}"
            }
        }
        
        meet {
            pkg_install!
        }
    }
end