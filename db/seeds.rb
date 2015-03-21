ActiveRecord::Base.connection.tables.each do |table|
  next if table == 'schema_migrations'
  next if table == 'users'
  table.classify.constantize.destroy_all
end

load File.expand_path("../seeds/countries.rb", __FILE__)
load File.expand_path("../seeds/themes.rb", __FILE__)

filepath = File.expand_path("../seeds/#{Rails.env}.rb", __FILE__)
load filepath if File.exist?(filepath)
