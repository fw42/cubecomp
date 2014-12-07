class CompetitionsController < ApplicationController
  before_action :load_competition
  before_action :redirect_if_no_locale
  before_action :load_locale_from_params
  before_action :load_theme_file

  def theme_file
    renderer = ThemeFileRenderer.new(theme_file: @theme_file, controller: self)
    render text: renderer.render
  end

  private

  def load_competition
    @competition = Competition.find_by!(handle: params[:competition_handle])
  end

  def load_locale_from_params
    @locale = @competition.locales.find_by!(handle: params[:locale])
    cookies[:locale] = @locale.handle
  end

  def load_theme_file
    filename = params[:theme_file] || 'index'
    extension = params[:format] || 'html'

    @theme_file = @competition.theme_files.text_files.with_filename(
      filename,
      @locale.handle,
      extension
    ).first!
  end

  def redirect_if_no_locale
    return if params[:locale]

    locale_from_cookie = if cookies[:locale]
      @competition.locales.find_by(handle: cookies[:locale])
    end

    redirect_to competition_area_path(
      @competition.handle,
      (locale_from_cookie || @competition.default_locale).handle
    )
  end
end
