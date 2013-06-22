class TabColorer

  def self.change_tab_color(red, green, blue)
    system("echo '\033]6;1;bg;red;brightness;#{red}\a'" + 
      "'\033]6;1;bg;green;brightness;#{green}\a'" +
      "'\033]6;1;bg;blue;brightness;#{blue}\a'")
  end

  def self.red_tab
    self.change_tab_color(240, 65, 35)
  end

  def self.green_tab
    self.change_tab_color(180, 210, 50)
  end

  def self.blue_tab
    self.change_tab_color(20, 190, 230)
  end

  def self.yellow_tab
    self.change_tab_color(255, 215, 45)
  end
end