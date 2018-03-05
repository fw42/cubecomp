class CompetitorsDropMaleColumn < ActiveRecord::Migration[5.1]
  def change
    remove_column :competitors, :male
  end
end
