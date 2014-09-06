class LocalesAddCompetitionId < ActiveRecord::Migration
  def up
    add_column :locales, :competition_id, :integer
    add_index :locales, :competition_id
  end

  def down
    remove_column :locales, :competition_id
  end
end
