class CreateDays < ActiveRecord::Migration
  def change
    create_table :days do |t|
      t.references :competition
      t.date :date
      t.timestamps
    end
  end
end
