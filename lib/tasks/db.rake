namespace :db do
  desc "Dumps the database to db/backup/"
  task :dump => :environment do
    host = ActiveRecord::Base.connection_config[:host]
    db = ActiveRecord::Base.connection_config[:database]
    user = ActiveRecord::Base.connection_config[:username]
    password = ActiveRecord::Base.connection_config[:password]

    filename = Time.now.strftime("%Y-%m-%d-%H-%M-%S") + ".sql.gz"
    dir = Rails.root.join("db/backup")
    cmd = "mkdir -p #{dir} && mysqldump --host=\"#{host}\" --user=\"#{user}\" --password=\"#{password}\" #{db} | gzip > #{dir}/#{filename}"
    exec cmd
  end
end
