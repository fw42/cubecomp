class Admin::ThemeFilesController < AdminController
  before_action :set_theme_file, only: [:edit, :update, :destroy]

  def index
    @theme_files = current_competition.theme_files.all
  end

  def new
    @competition = current_competition
    @theme_file = current_competition.theme_files.new
  end

  def edit
  end

  def create
    @competition = current_competition
    @theme_file = current_competition.theme_files.new(theme_file_params)

    if @theme_file.save
      redirect_to edit_admin_theme_file_path(@theme_file), notice: 'Theme file was successfully created.'
    else
      render :new
    end
  end

  def update
    if @theme_file.update(theme_file_params)
      redirect_to edit_admin_theme_file_path(@theme_file), notice: 'Theme file was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @theme_file.destroy
    redirect_to admin_competition_theme_files_url(current_competition), notice: 'Theme file was successfully destroyed.'
  end

  private

  def set_theme_file
    @theme_file = current_competition.theme_files.find(params[:id])
  end

  def theme_file_params
    params.require(:theme_file).permit(:filename, :content)
  end
end
