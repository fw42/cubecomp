class Admin::ThemeFilesController < AdminController
  include Admin::ThemeFilesHelper

  before_action :set_theme_files
  before_action :set_theme_file, only: [:edit, :show_image, :update, :destroy]
  before_action :ensure_user_has_permission_to_edit_themes

  def index
    @theme_files = @theme_files.order(:filename)
  end

  def new
    @theme_file = @theme_files.text_files.new
  end

  def new_from_existing
    @themes = Theme.all
    @competitions = current_user.policy.competitions

    if @theme
      @themes = @themes.where.not(id: @theme.id)
    else
      @competitions = @competitions.reject{ |competition| competition.id == current_competition.id }
    end

    @themes = @themes.pluck(:name, :id)
    @competitions = @competitions.map{ |c| [ c.name, c.id ] }
  end

  def create_from_existing
    from = existing_theme_files_to_load
    if from.nil?
      render_not_found
      return
    elsif from == :forbidden
      render_forbidden
      return
    end

    model = @theme || current_competition
    model.transaction do
      ThemeCopyService.new(@theme_files, from).replace_theme!(model)
    end

    redirect_to admin_theme_files_path, notice: "Theme successfully loaded."
  end

  def create
    @theme_file = @theme_files.new(theme_file_params)

    if @theme_file.save
      redirect_to admin_theme_files_path, notice: 'Theme file was successfully created.'
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
      redirect_to admin_theme_files_path, notice: 'Theme file was successfully created.'
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
    redirect_to admin_theme_files_path, notice: 'Theme file was successfully deleted.'
  end

  private

  def existing_theme_files_to_load
    from_params = params.require(:from).permit(:theme_id, :competition_id, :load_theme, :load_competition)

    if from_params[:load_theme]
      existing_theme_files_from_theme(from_params[:theme_id])
    elsif from_params[:load_competition]
      existing_theme_files_from_competition(from_params[:competition_id])
    end
  end

  def existing_theme_files_from_competition(competition_id)
    return unless competition_id
    competition = Competition.find_by!(id: competition_id)
    return :forbidden unless current_user.policy.login?(competition)
    competition.theme_files
  end

  def existing_theme_files_from_theme(theme_id)
    return unless theme_id
    return :forbidden unless current_user.policy.admin_user_menu?
    theme = Theme.find_by!(id: theme_id)
    theme.files
  end

  def set_theme_files
    if params[:theme_id]
      @theme = Theme.find_by!(id: params[:theme_id])
      @theme_files = @theme.files
    else
      @theme_files = current_competition.theme_files
    end
  end

  def set_theme_file
    @theme_file = @theme_files.find_by!(id: params[:id])
  end

  def ensure_user_has_permission_to_edit_themes
    return if @theme.nil?
    return if current_user.policy.admin_user_menu?
    render_forbidden
  end

  def theme_file_params
    params.require(:theme_file).permit(:filename, :content)
  end

  def theme_image_file_params
    params.require(:theme_file).permit(:filename, :image)
  end
end
