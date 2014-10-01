require 'test_helper'

class CompetitionTest < ActiveSupport::TestCase
  setup do
    @competition = competitions(:aachen_open)
  end

  test 'validates presence of name' do
    @competition.name = ''
    assert_not_valid(@competition, :name)

    @competition.name = nil
    assert_not_valid(@competition, :name)
  end

  test 'validates uniqueness of name' do
    new_competition = Competition.new
    new_competition.name = @competition.name
    assert_not_valid(new_competition, :name)
  end

  test 'validates presence of handle' do
    @competition.handle = ''
    assert_not_valid(@competition, :handle)

    @competition.handle = nil
    assert_not_valid(@competition, :handle)
  end

  test 'validates uniqueness of handle' do
    new_competition = Competition.new
    new_competition.handle = @competition.handle
    assert_not_valid(new_competition, :handle)
  end

  test 'validates presence of staff_email' do
    @competition.staff_email = ''
    assert_not_valid(@competition, :staff_email)

    @competition.staff_email = nil
    assert_not_valid(@competition, :staff_email)
  end

  test 'validates format of staff_email' do
    @competition.staff_email = 'foobar'
    assert_not_valid(@competition, :staff_email)
  end

  test 'validates presence of city_name' do
    @competition.city_name = ''
    assert_not_valid(@competition, :city_name)

    @competition.city_name = nil
    assert_not_valid(@competition, :city_name)
  end

  test 'validates presence and integrity of country' do
    @competition.country = nil
    assert_not_valid(@competition, :country)

    @competition.country_id = 12345
    assert_not_valid(@competition, :country)
  end

  test 'destroys competitors' do
    count = @competition.competitors.count
    assert_difference 'Competitor.count', -1 * count do
      @competition.destroy
    end
  end

  test 'destroys days' do
    count = @competition.days.count
    assert_difference 'Day.count', -1 * count do
      @competition.destroy
    end
  end

  test 'destroys day registrations' do
    count = @competition.day_registrations.count
    assert_difference 'DayRegistration.count', -1 * count do
      @competition.destroy
    end
  end

  test 'destroys events' do
    count = @competition.events.count
    assert_difference 'Event.count', -1 * count do
      @competition.destroy
    end
  end

  test 'destroys event_registrations' do
    count = @competition.event_registrations.count
    assert_difference 'EventRegistration.count', -1 * count do
      @competition.destroy
    end
  end

  test 'destroys news' do
    count = @competition.news.count
    assert_difference 'News.count', -1 * count do
      @competition.destroy
    end
  end

  test 'destroys permissions but not the users' do
    count = @competition.permissions.count
    assert_difference 'Permission.count', -1 * count do
      assert_no_difference 'User.count' do
        @competition.destroy
      end
    end
  end

  test 'destroys locales' do
    count = @competition.locales.count
    assert_difference 'Locale.count', -1 * count do
      @competition.destroy
    end
  end

  test 'destroys theme_files, but not themes' do
    count = @competition.theme_files.count
    assert_difference 'ThemeFile.count', -1 * count do
      assert_no_difference 'Theme.count' do
        @competition.destroy
      end
    end
  end

  test 'validates that delegate is allowed to be delegate' do
    @competition.delegate = users(:flo)
    assert_not_valid(@competition, :delegate)

    @competition.delegate = users(:delegate)
    assert_valid(@competition)
  end
end
