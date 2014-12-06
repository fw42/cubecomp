class ThemeFileRenderer
  def initialize(theme_file:, controller:)
    @theme_file = theme_file
    @competition = @theme_file.competition
    @controller = controller

    assign_drops
    assign_views
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
    assigns[:delegate] = @competition.delegate
    assigns[:owner] = @competition.owner
    assigns[:staff] = @competition.users
  end

  def assign_views
    assigns[:news] = ViewDrop.new(template: 'news', controller: @controller)
    assigns[:competitors] = ViewDrop.new(template: 'competitors', controller: @controller)

    assigns[:days] = @competition.days.map do |day|
      DayDrop.new(day: day, controller: @controller)
    end
  end
end
