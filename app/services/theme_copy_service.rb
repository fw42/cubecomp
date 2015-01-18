class ThemeCopyService
  def initialize(theme_files_to, theme_files_from = nil)
    @theme_files_to = theme_files_to
    @theme_files_from = theme_files_from
  end

  def replace_theme!(parent)
    remove_existing_theme_files_from_competition
    parent.save!

    copy_theme_to_competition
    parent.save!
  end

  def replace_theme
    # This doesn't actually work yet. Try again once
    # https://github.com/rails/rails/issues/18573 is
    # resolved. Can probably be used to simplify the
    # controller logic.
    remove_existing_theme_files_from_competition
    copy_theme_to_competition
  end

  def copy_theme_to_competition
    @theme_files_from.each do |theme_file|
      new_theme_file = theme_file.dup
      new_theme_file.theme = nil
      new_theme_file.competition = nil
      @theme_files_to.build(new_theme_file.attributes)
    end
  end

  def remove_existing_theme_files_from_competition
    @theme_files_to.each(&:mark_for_destruction)
  end
end
