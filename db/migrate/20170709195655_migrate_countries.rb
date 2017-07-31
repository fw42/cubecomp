class MigrateCountries < ActiveRecord::Migration[5.1]
  CHANGES = {
    "Aruba" => "Netherlands",
    "Korea" => "Republic of Korea",
    "USA" => "United States",
    "Puerto Rico" => "United States"
  }

  def up
    Country.transaction do
      import_all_missing_countries

      CHANGES.each do |old_name, new_name|
        puts "Renaming #{old_name} to #{new_name}"

        old_country = Country.find_by(name: old_name)
        next if old_country.nil?

        new_country = Country.find_by!(name: new_name)

        migrate_country(Competitor, old_country, new_country)
        migrate_country(Competition, old_country, new_country)
      end

      destroy_all_old_countries
    end
  end

  def down
  end

  private

  def import_all_missing_countries
    load Rails.root.join("db/seeds/countries.rb")
  end

  def migrate_country(model, old_country, new_country)
    model.where(country_id: old_country.id).find_each do |record|
      puts "-> Changing #{model} #{record.id} from #{old_country.name} (#{old_country.id}) to #{new_country.name} (#{new_country.id})"
      record.country = new_country
      record.save!
    end
  end

  def destroy_all_old_countries
    all_country_names = Country.pluck(:name)
    wca_country_names = Wca::Country.pluck(:name)
    old_country_names = all_country_names - wca_country_names

    old_country_names.each do |old_country_name|
      old_country = Country.find_by!(name: old_country_name)

      competitors = Competitor.where(country_id: old_country.id).size
      competitions = Competition.where(country_id: old_country.id).size
      if competitors + competitions > 0
        raise "Expected country to be unused!"
      end

      old_country.destroy!
    end
  end
end
