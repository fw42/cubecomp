filepath = File.expand_path("../countries.txt", __FILE__)

File.readlines(filepath).map(&:strip).each do |country_name|
  Country.transaction do
    puts "Creating country #{country_name}"
    Country.where(name: country_name).first_or_create!
  end
end
