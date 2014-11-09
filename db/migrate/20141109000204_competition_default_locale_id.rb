class CompetitionDefaultLocaleId < ActiveRecord::Migration
  def change
    add_column :competitions, :default_locale_id, :integer
  end
end
