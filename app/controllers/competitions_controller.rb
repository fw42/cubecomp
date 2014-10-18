class CompetitionsController < ApplicationController
  before_action :load_competition
  before_action :redirect_if_no_locale
  before_action :load_locale
  before_action :load_theme_file

  def theme_file
    renderer = ThemeFileRenderer.new(@theme_file)
    render text: renderer.render
  end

  private

  def load_competition
    @competition = Competition.find_by!(handle: params[:competition_handle])
  end

  def load_locale
    @locale = @competition.locales.find_by!(handle: params[:locale])
  end

  def load_theme_file
    filename = params[:theme_file] || 'index'
    extension = params[:format] || 'html'

    @theme_file = @competition.theme_files.text_files.for_filename(
      filename,
      @locale.handle,
      extension
    ).first!
  end

  def redirect_if_no_locale
    return if params[:locale]
    redirect_to competition_area_path(
      @competition.handle,
      @competition.default_locale.handle
    )
  end
end
