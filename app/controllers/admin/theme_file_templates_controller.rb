class Admin::ThemeFileTemplatesController < AdminController
  before_action :set_theme_and_template, only: [:edit, :update, :destroy]
  skip_before_action :ensure_current_competition

  def new
    @theme = Theme.find(params[:theme_id])
    @template = ThemeFile.new(theme_id: @theme.id)
  end

  def edit
  end

  def create
    @theme = Theme.find(params[:theme_id])
    @template = @theme.files.new(template_params)

    if @template.save
      redirect_to edit_admin_theme_theme_file_path(@theme, @template),
        notice: 'Template was successfully created.'
    else
      render :new
    end
  end

  def update
    if @template.update(template_params)
      redirect_to edit_admin_theme_theme_file_path(@theme, @template),
        notice: 'Theme file template was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @template.destroy
    redirect_to admin_theme_path(@theme),
      notice: 'Theme file template was successfully destroyed.'
  end

  private

  def set_theme_and_template
    @theme = Theme.find(params[:theme_id])
    @template = @theme.files.find(params[:id])
  end

  def template_params
    params.require(:theme_file).permit(:filename, :content)
  end
end
