class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.references :competition
      t.datetime :time
      t.string :locale
      t.string :text
      t.timestamps
    end
  end
end
