module LegacyModel
  extend ActiveSupport::Concern

  included do
    establish_connection(
      adapter: :sqlite3,
      pool: 5,
      timeout: 5000,
      database: ENV['LEGACY_DB']
    )

    self.table_name = table_name.gsub("legacy_", '')
  end
end
