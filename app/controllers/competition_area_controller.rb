class CompetitionAreaController < ApplicationController
  before_action :load_competition
  before_action :redirect_to_proper_domain
  before_action :redirect_if_no_locale
  before_action :load_locale_from_params
  before_action :load_theme_file
  before_action :load_layout_theme_file
  skip_before_action :verify_authenticity_token

  def render_theme_file
    renderer = ->{ render body: theme_file_renderer.render }

    respond_to do |format|
      format.css(&renderer)
      format.js(&renderer)
      format.html(&renderer)
      format.all(&renderer)
    end
  end

  private

  def theme_file_renderer
    return unless @theme_file

    @theme_file_renderer ||= ThemeFileRenderer.new(
      layout_theme_file: @layout_theme_file,
      theme_file: @theme_file,
      locale: @locale,
      controller: self
    )
  end

  def load_competition
    @competition = Competition.find_by!(handle: params[:competition_handle])
  end

  def load_locale_from_params
    @locale = @competition.locales.find_by!(handle: params[:locale])
    cookies.permanent[:locale] = @locale.handle
  end

  def load_layout_theme_file
    return if @theme_file && !@theme_file.html?
    @layout_theme_file = theme_file_loader.find_by!(filename: 'layout.html', locale: @locale.handle)
  end

  def load_theme_file
    filename = params[:theme_file] || 'index'
    extension = params[:format] || 'html'
    filename_with_extension = [ filename, extension ].join('.')

    @theme_file = theme_file_loader.find_by!(filename: filename_with_extension, locale: @locale.handle)
  end

  def redirect_to_proper_domain
    proper_domain, proper_protocol = proper_domain_and_protocol
    return if request.host == proper_domain && request.protocol == proper_protocol
    redirect_to "#{proper_protocol}#{proper_domain}#{request.fullpath}"
  end

  def proper_domain_and_protocol
    proper_domain = Cubecomp::Application.config.main_domain || request.host
    proper_protocol = Cubecomp::Application.config.main_domain_protocol || request.protocol

    if @competition.custom_domain.present?
      proper_domain = @competition.custom_domain
      proper_protocol = if @competition.custom_domain_force_ssl
        'https://'
      elsif proper_domain == request.host
        request.protocol
      else
        'http://'
      end
    end

    [ proper_domain, proper_protocol ]
  end

  def redirect_if_no_locale
    return if params[:locale]

    locale_from_cookie = if cookies[:locale] && Locale::ALL.key?(cookies[:locale])
      @competition.locales.find_by(handle: cookies[:locale])
    end

    redirect_to competition_area_path(
      @competition.handle,
      (locale_from_cookie || @competition.default_locale).handle
    )
  end

  def theme_file_loader
    @theme_file_loader ||= ThemeFileLoader.new(@competition.theme_files.text_files)
  end
end
