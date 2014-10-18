class Admin::ThemeFileTemplatesController < AdminController
  before_action :set_theme_and_template, only: [:edit, :update, :destroy]
  skip_before_action :ensure_current_competition

  def index
    render 'admin/theme_files/index'
  end

  def new
    @theme = Theme.find(params[:theme_id])
    @theme_file = @theme.files.new
    render 'admin/theme_files/new'
  end

  def edit
  end

  def create
    @theme = Theme.find(params[:theme_id])
    @theme_file = @theme.files.new(template_params)

    if @theme_file.save
      redirect_to edit_admin_theme_theme_file_path(@theme, @theme_file),
        notice: 'Template was successfully created.'
    else
      render :new
    end
  end

  def update
    if @theme_file.update(template_params)
      redirect_to edit_admin_theme_theme_file_path(@theme, @theme_file),
        notice: 'Theme file was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @theme_file.destroy
    redirect_to admin_theme_path(@theme),
      notice: 'Theme file template was successfully destroyed.'
  end

  private

  def set_theme_and_template
    @theme = Theme.find(params[:theme_id])
    @theme_file = @theme.files.find(params[:id])
  end

  def template_params
    params.require(:theme_file).permit(:filename, :content)
  end
end
