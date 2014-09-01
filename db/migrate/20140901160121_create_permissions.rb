class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.references :competition
      t.references :user
      t.boolean :admin, default: false
      t.timestamps
    end
  end
end
