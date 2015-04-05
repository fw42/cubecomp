class Admin::ThemeFilesController < AdminController
  include Admin::ThemeFilesHelper

  before_action :set_theme_files
  before_action :ensure_user_has_permission_to_edit_theme
  before_action :set_theme_file, only: [:edit, :show_image, :update, :destroy]

  def index
    @theme_files = @theme_files.order(:filename)
  end

  def new
    @theme_file = @theme_files.text_files.new
  end

  def import_files_form
    @themes = Theme.all
    @competitions = current_user.policy.competitions.sort_by(&:name)

    if @theme
      @themes = @themes.where.not(id: @theme.id)
    else
      @competitions = @competitions.reject{ |competition| competition.id == current_competition.id }
    end

    @themes = @themes.pluck(:name, :id)
    @competitions = @competitions.map{ |c| [ c.name, c.id ] }
  end

  def import_files
    from = record_to_import_theme_files_from
    if from.nil?
      render_not_found
      return
    elsif from == :forbidden
      render_forbidden
      return
    end

    to = @theme || current_competition
    to.transaction do
      ThemeFilesImportService.new(from, to).replace!
    end

    redirect_to admin_theme_files_path, notice: "Theme successfully imported."
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
      redirect_to admin_theme_files_path, notice: 'Theme file was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @theme_file.destroy
    redirect_to admin_theme_files_path, notice: 'Theme file was successfully deleted.'
  end

  private

  def record_to_import_theme_files_from
    from_params = params.require(:from).permit(:theme_id, :competition_id, :import_theme, :import_competition)

    if from_params[:import_theme]
      theme_to_import_theme_files_from(from_params[:theme_id])
    elsif from_params[:import_competition]
      competition_to_import_theme_files_from(from_params[:competition_id])
    end
  end

  def competition_to_import_theme_files_from(competition_id)
    return unless competition_id
    competition = Competition.find_by!(id: competition_id)
    return :forbidden unless current_user.policy.login?(competition)
    competition
  end

  def theme_to_import_theme_files_from(theme_id)
    return unless theme_id
    return :forbidden unless current_user.policy.admin_user_menu?
    Theme.find_by!(id: theme_id)
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

  def ensure_user_has_permission_to_edit_theme
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
