class ThemeFileRenderer
  def initialize(layout_theme_file:, theme_file:, locale:, controller:)
    @layout_theme_file = layout_theme_file
    @theme_file = theme_file
    @competition = @theme_file.competition
    @controller = controller
    @locale = locale

    assign_strings
    assign_drops
    assign_views
  end

  def render
    render_with_locale do
      if @layout_theme_file
        parsed_layout_file = Liquid::Template.parse(@layout_theme_file.content)
        assigns[:content_for_layout] = ->{ render_theme_file }
        render_with_registers(parsed_layout_file)
      else
        render_theme_file
      end
    end
  end

  def assigns
    @assigns ||= {}
  end

  def default_locals
    @default_locals ||= {
      :@theme_file => @theme_file,
      :@competition => @competition
    }
  end

  def read_template_file(filename)
    file = @competition.theme_files.text_files.with_filename(
      filename,
      @locale.handle,
    ).first

    file.try!(:content)
  end

  private

  def render_with_locale
    old_locale = I18n.locale
    I18n.locale = @locale.handle
    yield
  ensure
    I18n.locale = old_locale
  end

  def render_theme_file
    parsed_theme_file = Liquid::Template.parse(@theme_file.content)
    render_with_registers(parsed_theme_file)
  end

  def render_with_registers(parsed_template)
    parsed_template.registers[:file_system] = self
    parsed_template.registers[:competition] = @competition
    parsed_template.registers[:locale] = @locale
    parsed_template.render(assigns.stringify_keys)
  end

  def assign_strings
    assigns[:filename] = @theme_file.basename
  end

  def assign_drops
    assigns[:competition] = @competition
    assigns[:locale] = @locale
    assigns[:delegate] = ->{ @competition.delegate }
    assigns[:owner] = ->{ @competition.owner }
    assigns[:staff] = ->{ @competition.users }

    assigns[:days] = lambda do
      @competition.days.map do |day|
        DayDrop.new(day: day, controller: @controller)
      end
    end
  end

  def assign_views
    assigns[:default_headers] = ViewDrop.new(template: 'default_headers', controller: @controller)
    assigns[:news] = ViewDrop.new(template: 'news', controller: @controller, locals: { :@news => @locale.news })
    assign_competitors_view
    assign_registration_form_view
  end

  def assign_competitors_view
    assigns[:competitors] = lambda do
      ViewDrop.new(
        template: 'competitors',
        controller: @controller,
        locals: default_locals.reverse_merge({
          :@competitors => @competition.competitors.confirmed
            .includes(:country, :day_registrations, :event_registrations, :events),
          :@events => @competition.events.for_competitors_table.order(:handle)
        })
      )
    end
  end

  def assign_registration_form_view
    assigns[:registration_form] = lambda do
      ViewDrop.new(
        template: 'registration_form',
        controller: @controller,
        locals: default_locals.reverse_merge({
          :@competitor => @competition.competitors.new,
          :@days => @competition.days.with_events.preload(:events),
          :@return_to_path => @controller.request.fullpath
        })
      )
    end
  end
end
