require Rails.root.join("config/environment.rb")

namespace :db do
  namespace :seed do
    task :countries do
      load Rails.root.join("db/seeds/countries.rb")
    end

    task :themes do
      load Rails.root.join("db/seeds/themes.rb")
    end

    task :example_competition do
      load Rails.root.join("db/seeds/example_competition.rb")
    end

    task :wca do
      load Rails.root.join("db/seeds/wca.rb")
    end
  end
end
