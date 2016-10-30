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
    file = theme_file_loader.find_by(filename: filename, locale: @locale.handle)
    file.try!(:content)
  end

  private

  def theme_file_loader
    @theme_file_loader ||= ThemeFileLoader.new(@competition.theme_files.text_files)
  end

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
    assigns[:staff] = ->{ @competition.users.to_a }

    assigns[:days] = lambda do
      @competition.days.map do |day|
        DayDrop.new(day: day, controller: @controller)
      end
    end
  end

  def assign_views
    assign_headers_view
    assign_venue_map_view
    assign_news_view
    assign_stats_view
    assign_comparison_view
    assign_competitors_view
    assign_registration_form_view
  end

  def assign_headers_view
    assigns[:default_headers] = ViewDrop.new(template: 'default_headers', controller: @controller)
  end

  def assign_venue_map_view
    assigns[:venue_map] = lambda do
      ViewDrop.new(template: 'venue_map', controller: @controller, locals: default_locals)
    end
  end

  def assign_news_view
    assigns[:news] = lambda do
      ViewDrop.new(template: 'news', controller: @controller, locals: {
        :@news => @locale.news.order("time DESC")
      })
    end
  end

  def assign_stats_view
    assigns[:stats] = lambda do
      ViewDrop.new(template: 'stats', controller: @controller, locals: {
        :@stats => Highcharts.new(@competition)
      })
    end
  end

  def assign_comparison_view
    assigns[:comparison] = lambda do
      ViewDrop.new(template: 'comparison', controller: @controller, locals: locals_for_comparison_view)
    end
  end

  def assign_competitors_view
    assigns[:competitors] = lambda do
      ViewDrop.new(
        template: 'competitors',
        controller: @controller,
        locals: default_locals.reverse_merge({
          :@competitors => competitors_for_view,
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

  def locals_for_comparison_view
    events = @competition.events.for_competitors_table.wca
    event = events.detect{ |e| e.wca_handle == @controller.params[:event] } || events.first
    competitors = event ? event.competitors.confirmed.where.not(wca: nil).includes(:country) : []

    {
      :@event => event,
      :@events => events,
      :@competitors => competitors,
      :@singles => Wca::RanksSingle.for_event(competitors.map(&:wca), event.wca_handle),
      :@averages => Wca::RanksAverage.for_event(competitors.map(&:wca), event.wca_handle),
      :@sort_by => @controller.params[:sort_by]
    }
  end

  def competitors_for_view
    @competition
      .competitors
      .confirmed
      .includes(:country, :day_registrations, :event_registrations, :events)
      .reject{ |competitors| competitors.event_registrations.empty? }
  end
end
