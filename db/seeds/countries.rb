Wca::Country.all.each do |country|
  country_name = country.name
  Country.transaction do
    record = Country.where(name: country_name).first_or_initialize
    next if record.persisted?
    puts "Creating #{country_name}"
    record.save!
  end
end
