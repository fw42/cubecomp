class CompetitorsMigrateGenderColumn < ActiveRecord::Migration[5.1]
  def change
    migrate_competitors(male: true, gender: 'male')
    migrate_competitors(male: false, gender: 'female')
  end

  private

  def migrate_competitors(male:, gender:)
    Competitor.where(male: male).update_all(gender: gender)
  end
end
