class CompetitionDefaultLocaleIdUniq < ActiveRecord::Migration
  def change
    add_index :competitions, [ :default_locale_id ], unique: true
  end
end
