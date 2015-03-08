class CompetitionAreaController < ApplicationController
  before_action :load_competition
  before_action :redirect_if_no_locale
  before_action :load_locale_from_params
  before_action :load_layout_theme_file
  before_action :load_theme_file

  def render_theme_file
    render text: theme_file_renderer.render
  end

  private

  def theme_file_renderer
    return unless @theme_file

    @renderer ||= ThemeFileRenderer.new(
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
    cookies[:locale] = @locale.handle
  end

  def load_layout_theme_file
    @layout_theme_file = @competition.theme_files.text_files.with_filename(
      'layout.html',
      @locale.handle
    ).first!
  end

  def load_theme_file
    filename = params[:theme_file] || 'index'
    extension = params[:format] || 'html'

    @theme_file = @competition.theme_files.text_files.with_filename(
      "#{filename}.#{extension}",
      @locale.handle
    ).first!
  end

  def redirect_if_no_locale
    return if params[:locale]

    locale_from_cookie = if cookies[:locale] && Locale::ALL.keys.include?(cookies[:locale])
      @competition.locales.find_by(handle: cookies[:locale])
    end

    redirect_to competition_area_path(
      @competition.handle,
      (locale_from_cookie || @competition.default_locale).handle
    )
  end
end
