class ThemeFileRenderer
  attr_reader :theme_file

  def initialize(theme_file)
    @theme_file = theme_file
  end

  def render
    theme_file.content
  end
end
