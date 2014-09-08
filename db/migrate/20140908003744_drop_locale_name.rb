class DropLocaleName < ActiveRecord::Migration
  def change
    remove_column :locales, :name
  end
end
