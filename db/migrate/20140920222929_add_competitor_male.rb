class AddCompetitorMale < ActiveRecord::Migration
  def change
    add_column :competitors, :male, :boolean
  end
end
