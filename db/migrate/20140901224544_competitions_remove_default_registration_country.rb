class CompetitionsRemoveDefaultRegistrationCountry < ActiveRecord::Migration
  def up
    remove_column :competitions, :default_registration_country_id
  end

  def down
    add_column :competitions, :default_registration_country_id, :integer
  end
end
