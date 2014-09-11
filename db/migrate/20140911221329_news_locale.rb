class NewsLocale < ActiveRecord::Migration
  def change
    remove_column :news, :locale
    add_column :news, :locale_id, :integer
  end
end
