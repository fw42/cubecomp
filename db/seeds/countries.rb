filepath = File.expand_path("../countries.txt", __FILE__)

File.readlines(filepath).map(&:strip).each do |country_name|
  Country.transaction do
    puts "Creating country #{country_name}"
    Country.create!(name: country_name)
  end
end
