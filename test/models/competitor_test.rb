require 'test_helper'

class CompetitorTest < ActiveSupport::TestCase
  setup do
    @competitor = competitors(:flo_aachen_open)
  end

  test 'validates registered for at least one day' do
    @competitor.day_registrations = []
    assert_not_valid(@competitor, :base)
  end

  test 'validates presence and integrity of competition' do
    @competitor.competition = nil
    assert_not_valid(@competitor, :competition)

    @competitor.competition_id = 1234
    assert_not_valid(@competitor, :competition)
  end

  test 'does not validate presence of wca id' do
    @competitor.wca = ''
    assert_valid @competitor

    @competitor.wca = nil
    assert_valid @competitor
  end

  test 'validates uniqueness of wca id, but only scoped to competition' do
    new_competitor = @competitor.dup
    assert_not_valid(new_competitor, :wca)

    new_competitor.competition = competitions(:german_open)
    RegistrationService.new(new_competitor).register_for_day(new_competitor.competition.days.first.id)
    assert_valid new_competitor
  end

  test 'validates format of wca id' do
    @competitor.wca = 'bullshit'
    assert_not_valid(@competitor, :wca)
  end

  test 'validates presence of first name' do
    @competitor.first_name = ''
    assert_not_valid(@competitor, :first_name)

    @competitor.first_name = nil
    assert_not_valid(@competitor, :first_name)
  end

  test 'validates presence of last name' do
    @competitor.last_name = ''
    assert_not_valid(@competitor, :last_name)

    @competitor.last_name = nil
    assert_not_valid(@competitor, :last_name)
  end

  test 'validates presence and format of email' do
    @competitor.email = ''
    assert_not_valid(@competitor, :email)

    @competitor.email = nil
    assert_not_valid(@competitor, :email)

    @competitor.email = 'foobar'
    assert_not_valid(@competitor, :email)

    @competitor.email = 'foobar@google.com'
    assert_valid @competitor
  end

  test 'validates on create that email domain has valid DNS MX record' do
    competitor = Competitor.new
    competitor.email = 'email@invalid-domain.foo'
    assert_not_valid(competitor, :email)
  end

  test 'validates on update that email domain has valid DNS MX record, but only if email was changed' do
    @competitor.email = 'email@invalid-domain.foo'
    @competitor.save!(validate: false)
    assert_valid(@competitor)

    @competitor.first_name = 'some other unrelated change'
    @competitor.email = 'email@invalid-domain.foo'
    assert_valid(@competitor)

    @competitor.email = 'bla@invalid-domain.foo'
    assert_not_valid(@competitor, :email)
  end

  test 'validates presence and sanity of birthday' do
    @competitor.birthday = nil
    assert_not_valid(@competitor, :birthday)

    @competitor.birthday = ''
    assert_not_valid(@competitor, :birthday)

    @competitor.birthday = Date.today - 200.years
    assert_not_valid(@competitor, :birthday)

    @competitor.birthday = Date.today
    assert_not_valid(@competitor, :birthday)

    @competitor.birthday = Date.parse('1985-12-18')
    assert_valid @competitor
  end

  test 'validates presence and integrity of country' do
    @competitor.country = nil
    assert_not_valid(@competitor, :country)

    @competitor.country_id = 1234
    assert_not_valid(@competitor, :country)
  end

  test 'destroying competitor destroys event_registrations but not events' do
    count = @competitor.event_registrations.count
    assert_difference 'EventRegistration.count', -1 * count do
      assert_no_difference 'Event.count' do
        @competitor.destroy
      end
    end
  end

  test 'destroying competitor destroys day_registrations but not days' do
    count = @competitor.day_registrations.count
    assert_difference 'DayRegistration.count', -1 * count do
      assert_no_difference 'Day.count' do
        @competitor.destroy
      end
    end
  end

  test 'gender is unspecified by default on new instances' do
    competitor = Competitor.new
    assert_nil competitor.gender
  end

  test 'validates that gender is specified and not nil' do
    @competitor.gender = nil
    refute @competitor.male?
    refute @competitor.female?
    assert_not_valid(@competitor, :gender)

    @competitor.gender = 'dog'
    refute @competitor.male?
    refute @competitor.female?
    assert_not_valid(@competitor, :gender)

    @competitor.gender = 'male'
    assert @competitor.male?
    refute @competitor.female?
    assert_valid(@competitor)

    @competitor.gender = 'female'
    refute @competitor.male?
    assert @competitor.female?
    assert_valid(@competitor)

    @competitor.gender = 'other'
    refute @competitor.male?
    refute @competitor.female?
    assert_valid(@competitor)
  end

  test 'registered_on?, competing_on?, and guest_on?' do
    @competitor.day_registrations = []
    @competitor.event_registrations = []

    day = @competitor.competition.days.first

    assert_equal false, @competitor.registered_on?(day)
    assert_equal false, @competitor.registered_on?(day.id)
    assert_equal false, @competitor.competing_on?(day)
    assert_equal false, @competitor.competing_on?(day.id)
    assert_equal false, @competitor.guest_on?(day)
    assert_equal false, @competitor.guest_on?(day.id)
    assert_equal false, @competitor.competing?

    RegistrationService.new(@competitor).register_for_day(day.id)
    assert_equal true, @competitor.registered_on?(day)
    assert_equal true, @competitor.registered_on?(day.id)
    assert_equal false, @competitor.competing_on?(day)
    assert_equal false, @competitor.competing_on?(day.id)
    assert_equal true, @competitor.guest_on?(day)
    assert_equal true, @competitor.guest_on?(day.id)
    assert_equal false, @competitor.competing?

    RegistrationService.new(@competitor).register_for_event(day.events.first, true)
    assert_equal true, @competitor.registered_on?(day)
    assert_equal true, @competitor.registered_on?(day.id)
    assert_equal false, @competitor.competing_on?(day)
    assert_equal false, @competitor.competing_on?(day.id)
    assert_equal true, @competitor.guest_on?(day)
    assert_equal true, @competitor.guest_on?(day.id)
    assert_equal false, @competitor.competing?

    RegistrationService.new(@competitor).register_for_event(day.events.first, false)
    assert_equal true, @competitor.registered_on?(day)
    assert_equal true, @competitor.registered_on?(day.id)
    assert_equal true, @competitor.competing_on?(day)
    assert_equal true, @competitor.competing_on?(day.id)
    assert_equal false, @competitor.guest_on?(day)
    assert_equal false, @competitor.guest_on?(day.id)
    assert_equal true, @competitor.competing?
  end

  test 'event_registration_status' do
    event = events(:aachen_open_rubiks_cube)

    @competitor.event_registrations.each(&:destroy!)
    assert_equal 'not_registered', @competitor.reload.event_registration_status(event)

    registration = @competitor.event_registrations.create!(
      event: event,
      competition: @competitor.competition
    )
    assert_equal 'registered', @competitor.event_registration_status(event)

    registration.update(waiting: true)
    assert_equal 'waiting', @competitor.event_registration_status(event)

    other_event = events(:aachen_open_rubiks_professor)
    assert_equal 'not_registered', @competitor.event_registration_status(other_event)
  end

  test '#age' do
    competitor = Competitor.new
    competitor.birthday = '1985-10-03'

    Timecop.freeze(Time.parse('2014-10-01')) do
      assert_equal 28, competitor.age
    end

    Timecop.freeze(Time.parse('2014-10-03')) do
      assert_equal 29, competitor.age
    end

    Timecop.freeze(Time.parse('2014-10-04')) do
      assert_equal 29, competitor.age
    end

    Timecop.freeze(Time.parse('2014-11-01')) do
      assert_equal 29, competitor.age
    end

    Timecop.freeze('2016-02-29') do
      assert_equal 30, competitor.age
    end

    Timecop.freeze('1986-12-18') do
      assert_equal 1, competitor.age
    end

    competitor.birthday = '2000-02-29'

    Timecop.freeze('2014-10-01') do
      assert_equal 14, competitor.age
    end
  end

  test '#birthday_on?' do
    date = @competitor.competition.days.first.date
    @competitor.birthday = date
    assert @competitor.birthday_on?(date)
  end

  test '#birthday_on_competition?' do
    date = @competitor.competition.days.first.date
    @competitor.birthday = date
    assert true, @competitor.birthday_on_competition?
  end

  test '#wca_url' do
    assert_equal "http://www.worldcubeassociation.org/results/p.php?i=#{@competitor.wca}", @competitor.wca_url
  end
end
