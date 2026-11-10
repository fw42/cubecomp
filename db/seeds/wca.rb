db_config = ActiveRecord::Base.configurations.configs_for(env_name: 'wca').first

if db_config.nil?
  raise "Missing wca entry in config/database.yml"
end

config = db_config.configuration_hash

database = config[:database] or raise "Missing 'database' entry in wca database config"
username = config[:username] or raise "Missing 'username' entry in wca database config"
password = config[:password] || ""

dir = Rails.root.join("tmp", "wca").to_s
Dir.mkdir(dir) unless File.exist?(dir)

script = Rails.root.join("scripts", "wca_db_update.sh").to_s

system(script, database, username, password, dir)
