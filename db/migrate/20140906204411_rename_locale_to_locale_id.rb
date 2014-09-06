class RenameLocaleToLocaleId < ActiveRecord::Migration
  def up
    remove_column :pages, :locale
    add_column :pages, :locale_id, :integer
  end

  def down
    remove_column :pages, :locale_id
    add_column :pages, :locale, :string
  end
end
