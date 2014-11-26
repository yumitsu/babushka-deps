dep 'userbin', :path do
    path.default! File.absolute_path("~/bin")
    met? {
        path.dir? and in_path? path
    }

    meet {
        # nothing yet
    }
end
