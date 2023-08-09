namespace :db do
  desc "Dumps the database to db/backup/"
  task dump: :environment do
    host = ActiveRecord::Base.connection_config[:host]
    db = ActiveRecord::Base.connection_config[:database]
    user = ActiveRecord::Base.connection_config[:username]
    password = ActiveRecord::Base.connection_config[:password]

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
      ActiveRecord::SchemaDumper.dump(Wca::Person.connection, file)
    end
  end

  task :load_wca_schema do
    config = ActiveRecord::Base.configurations
    ActiveRecord::Base.connection.recreate_database(config['wca'][:database])

    ActiveRecord::Base.establish_connection(config['wca'])
    ActiveRecord::Schema.verbose = false

    load(Rails.root.join("db", "schema.wca.rb"))
  end
end
