class EmailTemplateRenderer
  def initialize(email_template, competitor, current_user)
    @email_template = email_template
    @competition = @email_template.competition
    @competitor = competitor
    @current_user = current_user

    assign_drops
  end

  def render_subject
    render_liquid(@email_template.subject)
  end

  def render_content
    render_liquid(@email_template.content)
  end

  def assigns
    @assigns ||= {}
  end

  private

  def render_liquid(liquid_template)
    parsed = Liquid::Template.parse(liquid_template)
    parsed.registers[:competition] = @competition
    parsed.render(assigns.stringify_keys)
  end

  def assign_drops
    assigns[:competitor] = @competitor
    assigns[:competition] = @competition
    assigns[:user] = @current_user
  end
end
