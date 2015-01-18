module Admin::ThemeFilesHelper
  def index_title
    if @theme
      @theme.name
    else
      'Theme'
    end
  end

  def admin_theme_files_path
    if @theme
      admin_theme_theme_files_path(@theme)
    else
      admin_competition_theme_files_path(current_competition)
    end
  end

  def admin_theme_file_path(theme_file)
    if @theme
      admin_theme_theme_file_path(@theme, theme_file)
    else
      admin_competition_theme_file_path(current_competition, theme_file)
    end
  end

  def show_image_admin_theme_file_path(theme_file)
    if @theme
      show_image_admin_theme_theme_file_path(@theme, theme_file)
    else
      show_image_admin_competition_theme_file_path(current_competition, theme_file)
    end
  end

  def edit_admin_theme_file_path(theme_file)
    if @theme
      edit_admin_theme_theme_file_path(@theme, theme_file)
    else
      edit_admin_competition_theme_file_path(current_competition, theme_file)
    end
  end

  def new_admin_theme_file_path
    if @theme
      new_admin_theme_theme_file_path(@theme)
    else
      new_admin_competition_theme_file_path(current_competition)
    end
  end

  def new_image_admin_theme_file_path
    if @theme
      new_image_admin_theme_theme_files_path(@theme)
    else
      new_image_admin_competition_theme_files_path(current_competition)
    end
  end

  def new_from_existing_admin_theme_files_path
    if @theme
      new_from_existing_admin_theme_theme_files_path(@theme)
    else
      new_from_existing_admin_competition_theme_files_path(current_competition)
    end
  end

  def create_from_existing_admin_theme_files_path
    if @theme
      create_from_existing_admin_theme_theme_files_path(@theme)
    else
      create_from_existing_admin_competition_theme_files_path(current_competition)
    end
  end

  def create_image_admin_theme_files_path
    if @theme
      create_image_admin_theme_theme_files_path(@theme)
    else
      create_image_admin_competition_theme_files_path(current_competition)
    end
  end

  def theme_file_for_form(theme_file)
    if theme_file.persisted?
      [:admin, theme_file]
    elsif @theme
      [:admin, @theme, theme_file]
    else
      [:admin, current_competition, theme_file]
    end
  end

  def back_button_url
    if @theme
      admin_theme_theme_files_path(@theme)
    else
      admin_competition_theme_files_path(current_competition)
    end
  end
end
