require 'forgery'

ActiveRecord::Base.connection.tables.each do |table|
  next if table == 'schema_migrations'
  next if table == 'users'
  table.classify.constantize.destroy_all
end

EVENTS = [
  {
    name_short: "3x3x3",
    name: "Rubik's Cube",
    handle: "3"
  },
  {
    name_short: "4x4x4",
    name: "Rubik's Revenge",
    handle: "4"
  },
  {
    name_short: "5x5x5",
    name: "Rubik's Professor",
    handle: "5"
  },
  {
    name_short: "3x3 bld",
    name: "Rubik's Cube blind",
    handle: "3b"
  }
]

%w(Germany Brazil Canada USA).each do |name|
  Country.create!(name: name)
end
germany = Country.find_by_name("Germany")

def create_day(competition)
  last_date = competition.days.order(:date).last
  new_date = if last_date
    last_date.date + 1.day
  else
    Forgery::Date.date(future: true)
  end

  Day.create!(
    competition: competition,
    date: new_date,
    entrance_fee_competitors: Forgery(:monetary).money,
    entrance_fee_guests: Forgery(:monetary).money
  )
end

def create_event(competition, event)
  Event.create!({
    competition: competition,
    day: competition.days.to_a.sample,
    state: 'open_for_registration',
    start_time: Time.new(2000, 1, 1, rand(24), rand(60)),
    length_in_minutes: 30 + rand(60),
    max_number_of_registrations: 10 + rand(100),
    round: "First round",
    timelimit: "10:00",
    format: "Average of 5"
  }.merge(event))
end

def create_competitor(competition)
  competitor = Competitor.create!(
    competition: competition,
    first_name: Forgery::Name.first_name,
    last_name: Forgery::Name.last_name,
    email: Forgery(:internet).email_address,
    birthday: Date.today - 10.years - rand(50*365).days,
    state: Competitor::STATES.sample,
    country: Country.all.to_a.sample,
    male: rand(2) == 0,
    staff: rand < 0.1,
    local: rand < 0.2,
    paid: rand < 0.2
  )

  if rand < 0.1
    competitor.birthday = competition.days.to_a.sample.date - (10 + rand(10)).years
  end

  if rand < 0.5
    competitor.wca = "#{2000 + rand(14)}#{competitor.last_name.upcase}#{rand(10)}"
  end

  if rand < 0.2
    competitor.user_comment = Forgery(:lorem_ipsum).words(rand(20))
  end

  if rand < 0.1
    competitor.admin_comment = Forgery(:lorem_ipsum).words(10)
  end

  if rand < 0.3
    competitor.free_entrance = true

    if rand < 0.5
      competitor.free_entrance_reason = Forgery(:lorem_ipsum).words(5)
    end
  end

  competitor.save!

  events = 0
  competition.events.where(state: 'open_for_registration').to_a.shuffle.each do |event|
    if events == 0 || rand < 0.3
      RegistrationService.new(competitor).register_for_event(event)
      events += 1
    end
  end

  competition.days.each do |day|
    if !competitor.competing_on?(day) && rand < 0.25
      RegistrationService.new(competitor).register_as_guest(day)
    end
  end

  puts "Creating competitor #{competitor.name}"
  competitor.reload
end


def create_associations(competition)
  create_day(competition)
  create_day(competition)
  competition.reload

  competition.locales.create(handle: 'de')
  competition.locales.create(handle: 'en')

  EVENTS.each do |event|
    create_event(competition, event)
  end

  50.times do
    create_competitor(competition)
  end

  competition.theme_files.create!(
    filename: 'index.html',
    content: <<-HTML
<html>
  <body>
    <h1>{{ competition.name }}</h1>
    Welcome!
  </body>
</html>
    HTML
  )
end

def create_user(params)
  user = User.where(params.except(:password, :password_confirmation))
  user.first_or_create!(params.slice(:password, :password_confirmation))
  user
end

create_user(
  first_name: "WCA",
  last_name: "Delegate",
  email: "delegate@wca.com",
  password: "delegate123",
  password_confirmation: "delegate123",
  permission_level: User::PERMISSION_LEVELS[:regular],
  delegate: true
)

create_user(
  first_name: "Regular",
  last_name: "User",
  email: "regular@user.com",
  password: "regular123",
  password_confirmation: "regular123",
  permission_level: User::PERMISSION_LEVELS[:regular]
)

create_user(
  first_name: "Florian",
  last_name: "Weingarten",
  email: "flo@hackvalue.de",
  password: "floflo123",
  password_confirmation: "floflo123",
  permission_level: User::PERMISSION_LEVELS[:superadmin]
)

create_user(
  first_name: "Average",
  last_name: "Joe",
  email: "admin@admin.com",
  password: "admin123",
  password_confirmation: "admin123",
  permission_level: User::PERMISSION_LEVELS[:superadmin]
)

locales = [Locale.new(handle: "de"), Locale.new(handle: "en")]
days = [Day.new(date: Date.new(2014, 2, 13), entrance_fee_guests: 0, entrance_fee_competitors: 12)]

competition = Competition.create!(
  name: "Aachen Open 2014",
  handle: "ao14",
  staff_email: "foo@bar.com",
  staff_name: "Mister Staff",
  city_name: "Aachen",
  city_name_short: "AC",
  country: germany,
  locales: locales,
  days: days
)

create_associations(competition)
