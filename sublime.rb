dep 'Sublime Text.installer', :major_version do
  major_version.default! 3

  def set_source!
      if major_version == 2
          source "http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2.dmg"
      elsif major_version == 3
          source "http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%20Build%203065.dmg"
      end
      provides "Sublime Text #{major_version}"
  end

  setup {
      set_source!
  }
end