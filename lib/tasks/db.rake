namespace :db do
  desc "Dumps the database to db/backup/"
  task dump: :environment do
    config = ActiveRecord::Base.connection_db_config.configuration_hash
    host = config[:host]
    db = config[:database]
    user = config[:username]
    password = config[:password]

    filename = Time.now.strftime("%Y-%m-%d-%H-%M-%S") + ".sql.gz"
    dir = Rails.root.join("db/backup")

    cmd = "" \
      "mkdir -p #{dir} &&" \
      "mysqldump --host=\"#{host}\" --user=\"#{user}\" #{db}" \
      "| gzip > #{dir}/#{filename}"

    ENV['MYSQL_PWD'] = password

    exec cmd
  end

  desc "Dumps the schema of the WCA database"
  task dump_wca_schema: :environment do
    path = Rails.root.join("db", "schema.wca.rb")
    File.open(path, 'w') do |file|
      ActiveRecord::SchemaDumper.dump(Wca::Person.connection_pool, file)
    end
  end

  task :load_wca_schema do
    config = ActiveRecord::Base.configurations.configs_for(env_name: 'wca').first
    ActiveRecord::Base.with_connection { |connection| connection.recreate_database(config.database) }

    ActiveRecord::Base.establish_connection(config)
    ActiveRecord::Schema.verbose = false

    load(Rails.root.join("db", "schema.wca.rb"))
  end
end
