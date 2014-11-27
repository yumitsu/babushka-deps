dep 'yest.src' do
    source "http://sourceforge.net/projects/yest/files/latest/download?source=files"
    provides 'yest >= 2.7.0.7'

    PATHS = {
        :brew => (shell "brew --prefix" / "bin"),
        :home => ("~" / "bin"),
        :usr  => "/usr/bin"
    }

    def root?
        shell "whoami" == "root"
    end

    def path_accessible? query
        path = if query.is_a?(Symbol)
            PATHS.has_key?(query) ? PATHS.values_at(query) : PATHS[:usr]
        else
            query
        end
        path = File.expand_path path
        
        (File.directory?(path) and File.writeable?(path))
    end

    def prefix
        if host.osx?
            if in_path? 'brew'
                dir = (shell "brew --prefix" / "bin")

                if dir.p.exists?
                    return dir
                end
            end
            


        else
        end
    end

    build {
        shell "gcc -o yest-*.c"
    }

    install {
        #shell "cp yest"
    }

    # met? {
    #     in_path? 'yest' and in_path? 'gcc'
    # }

    # meet {
    #     Babushka::Resource.extract source_uri do |path|
    #         shell
    #     end
    # }
end