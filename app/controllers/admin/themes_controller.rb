class Admin::ThemesController < AdminController
  before_action :set_theme, only: [:show]

  def index
    @themes = Theme.all
  end

  def show
  end

  private

  def set_theme
    @theme = Theme.find(params[:id])
  end
end
