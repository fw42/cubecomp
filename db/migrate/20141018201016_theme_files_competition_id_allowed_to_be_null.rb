class ThemeFilesCompetitionIdAllowedToBeNull < ActiveRecord::Migration
  def change
    change_column_null :theme_files, :competition_id, true
  end
end
