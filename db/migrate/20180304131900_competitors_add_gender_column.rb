class CompetitorsAddGenderColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :competitors, :gender, :string, null: false
  end
end
