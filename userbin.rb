dep 'userbin' do
    def path
        File.absolute_path("~/bin")
    end

    met? {
        path.dir? and in_path? path
    }

    meet {
        # nothing yet
    }
end
