class Admin::ThemeFilesController < AdminController
  before_action :set_theme_files, only: [:index, :new, :new_image, :create, :create_image]
  before_action :set_theme_file, only: [:edit, :show_image, :update, :destroy]

  def index
    @theme_files = @theme_files.order(:filename)
  end

  def new
    @theme_file = @theme_files.text_files.new
  end

  def create
    @theme_file = @theme_files.new(theme_file_params)

    if @theme_file.save
      redirect_to index_url, notice: 'Theme file was successfully created.'
    else
      render :new
    end
  end

  def new_image
    @theme_file = @theme_files.image_files.new
  end

  def create_image
    @theme_file = @theme_files.new(theme_image_file_params)

    if @theme_file.save
      redirect_to index_url, notice: 'Theme file was successfully created.'
    else
      @theme_file.errors.delete(:image)
      render :new_image
    end
  end

  def show_image
    @theme_file = @theme_files.image_files.find(params[:id])
  end

  def edit
  end

  def update
    if @theme_file.update(theme_file_params)
      redirect_to edit_admin_theme_file_path(@theme_file),
        notice: 'Theme file was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @theme_file.destroy
    redirect_to index_url, notice: 'Theme file was successfully deleted.'
  end

  private

  def index_url
    if @theme
      admin_theme_theme_files_path(@theme)
    else
      admin_competition_theme_files_path(current_competition)
    end
  end

  def set_theme_files
    if params[:theme_id]
      @theme = Theme.find(params[:theme_id])
      @theme_files = @theme.files
    else
      @theme_files = current_competition.theme_files
    end
  end

  def set_theme_file
    @theme_files ||= ThemeFile.all
    @theme_file = @theme_files.find(params[:id])
    @theme ||= @theme_file.theme
  end

  def theme_file_params
    params.require(:theme_file).permit(:filename, :content)
  end

  def theme_image_file_params
    params.require(:theme_file).permit(:filename, :image)
  end
end
