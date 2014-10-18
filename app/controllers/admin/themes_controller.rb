class Admin::ThemesController < AdminController
  before_action :set_theme, only: [:show, :edit, :update, :destroy]
  skip_before_action :ensure_current_competition

  def index
    @themes = Theme.all
  end

  def new
    @theme = Theme.new
  end

  def show
  end

  def edit
  end

  def create
    @theme = Theme.new(theme_params)

    if @theme.save
      redirect_to admin_themes_path
    else
      render :new
    end
  end

  def update
    if @theme.update(theme_params)
      redirect_to admin_themes_path, notice: 'Theme was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @theme.destroy
    redirect_to admin_themes_path, notice: 'Theme was successfully deleted.'
  end

  private

  def set_theme
    @theme = Theme.find(params[:id])
  end

  def theme_params
    params.require(:theme).permit(:name)
  end
end
