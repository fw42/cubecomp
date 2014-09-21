class AddKeys2 < ActiveRecord::Migration
  def change
    add_foreign_key "competitions", "countries", name: "competitions_country_id_fk"
    add_foreign_key "competitions", "users", name: "competitions_delegate_user_id_fk", column: "delegate_user_id"
    add_foreign_key "competitors", "competitions", name: "competitors_competition_id_fk"
    add_foreign_key "competitors", "countries", name: "competitors_country_id_fk"
    add_foreign_key "day_registrations", "competitions", name: "day_registrations_competition_id_fk"
    add_foreign_key "day_registrations", "competitors", name: "day_registrations_competitor_id_fk"
    add_foreign_key "day_registrations", "days", name: "day_registrations_day_id_fk"
    add_foreign_key "days", "competitions", name: "days_competition_id_fk"
    add_foreign_key "event_registrations", "competitions", name: "event_registrations_competition_id_fk"
    add_foreign_key "event_registrations", "competitors", name: "event_registrations_competitor_id_fk"
    add_foreign_key "event_registrations", "events", name: "event_registrations_event_id_fk"
    add_foreign_key "events", "competitions", name: "events_competition_id_fk"
    add_foreign_key "events", "days", name: "events_day_id_fk"
    add_foreign_key "locales", "competitions", name: "locales_competition_id_fk"
    add_foreign_key "news", "competitions", name: "news_competition_id_fk"
    add_foreign_key "news", "locales", name: "news_locale_id_fk"
    add_foreign_key "permissions", "competitions", name: "permissions_competition_id_fk"
    add_foreign_key "permissions", "users", name: "permissions_user_id_fk"
    add_foreign_key "theme_file_templates", "themes", name: "theme_file_templates_theme_id_fk"
    add_foreign_key "theme_files", "competitions", name: "theme_files_competition_id_fk"
  end
end
