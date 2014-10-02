%w(Germany Brazil Canada USA).each do |name|
  Country.create!(name: name)
end

User.create!(first_name: "Average", last_name: "Joe", email: "admin@admin.com", password: "admin", password_confirmation: "admin", permission_level: User::PERMISSION_LEVELS[:superadmin])

germany = Country.find_by_name("Germany")
aachen_open = Competition.create!(name: "Aachen Open 2014", handle: "aachen-open-2014", staff_email: "foo@bar.com", staff_name: "Mister Staff", city_name: "Aachen", country: germany)
first_day = Day.create!(competition: aachen_open, date: Date.new(2014, 10, 4), entrance_fee_competitors: 5, entrance_fee_guests: 5)
Day.create!(competition: aachen_open, date: Date.new(2014, 10, 5), entrance_fee_competitors: 10, entrance_fee_guests: 5)

Event.create(competition: aachen_open, day: first_day, name_short: "3x3x3", name: "Rubik's Cube", handle: "3x3x3", state: 'open_for_registration', start_time: Time.new(2014, 10, 4, 13, 00), length_in_minutes: 120, max_number_of_registrations: 23, round: "First round", timelimit: "10:00min", format: "Average of 5")
