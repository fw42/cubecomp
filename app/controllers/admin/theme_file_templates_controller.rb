class Admin::ThemeFileTemplatesController < AdminController
  before_action :set_template, only: [:edit, :update, :destroy]

  def new
    @theme = Theme.find(params[:theme_id])
    @template = ThemeFileTemplate.new
  end

  def edit
  end

  def create
    @theme = Theme.find(params[:theme_id])
    @template = @theme.file_templates.new(template_params)

    if @template.save
      redirect_to edit_admin_theme_file_template_path(@template), notice: 'Template was successfully created.'
    else
      render :new
    end
  end

  def update
    if @template.update(template_params)
      redirect_to edit_admin_theme_file_template_path(@template), notice: 'Theme file template was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @template.destroy
    redirect_to admin_theme_path(@template.theme), notice: 'Theme file template was successfully destroyed.'
  end

  private

  def set_template
    @template = ThemeFileTemplate.find(params[:id])
  end

  def template_params
    params.require(:theme_file_template).permit(:filename, :content)
  end
end
