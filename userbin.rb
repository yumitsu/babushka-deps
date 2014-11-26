dep 'user bin' do
    met? {
        "~/bin".p.exists? and in_path?(File.absolute_path("~/bin"))
    }

    meet {
        # nothing yet
    }
end
