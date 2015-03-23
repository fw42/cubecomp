class ThemeFilesImportService
  def initialize(from_competition_or_theme, to_competition_or_theme)
    @from_competition_or_theme = from_competition_or_theme
    @to_competition_or_theme = to_competition_or_theme
  end

  # Shitty workaround for
  # https://github.com/rails/rails/issues/18573 is
  def replace!
    remove_existing_theme_files
    @to_competition_or_theme.save!

    copy_theme_files
    @to_competition_or_theme.save!
  end

  private

  def copy_theme_files
    from_theme_files.each do |theme_file|
      new_theme_file = theme_file.dup
      new_theme_file.theme = nil
      new_theme_file.competition = nil
      new_theme_file = to_theme_files.build(new_theme_file.attributes)
      new_theme_file.image = theme_file.image if theme_file.image?
    end
  end

  def remove_existing_theme_files
    to_theme_files.each(&:mark_for_destruction)
  end

  def to_theme_files
    case @to_competition_or_theme
    when Competition
      @to_competition_or_theme.theme_files
    when Theme
      @to_competition_or_theme.files
    end
  end

  def from_theme_files
    case @from_competition_or_theme
    when Competition
      @from_competition_or_theme.theme_files
    when Theme
      @from_competition_or_theme.files
    end
  end
end
