class ThemeFileRenderer
  def initialize(theme_file)
    @theme_file = theme_file
    @competition = @theme_file.competition

    assign_drops
  end

  def render
    parsed = Liquid::Template.parse(@theme_file.content)
    parsed.registers[:file_system] = self
    parsed.registers[:competition] = @competition
    parsed.render(assigns.stringify_keys)
  end

  def assigns
    @assigns ||= {}
  end

  def read_template_file(filename)
    file = @competition.theme_files.find_by(filename: filename)
    raise Liquid::Error, 'File does not exist' if file.nil?
    file.content
  end

  private

  def assign_drops
    assigns[:competition] = @competition
    assigns[:staff] = @competition.users
  end
end
