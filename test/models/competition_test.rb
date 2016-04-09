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

  test 'validates presence of days' do
    @competition.days.destroy_all
    refute @competition.valid?
    assert_match /at least one day/, @competition.errors[:base].first
  end

  test 'validates presence of locales' do
    @competition.locales.destroy_all
    refute @competition.valid?
    assert_match /at least one language/, @competition.errors[:base].first
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

  test 'destroys email templates' do
    count = @competition.email_templates.count
    assert_difference 'EmailTemplate.count', -1 * count do
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

  test 'validates that the owner has permission to login' do
    @competition.owner = users(:flo)
    @competition.owner.policy.expects(:login?).with(@competition).returns(false)
    assert_not_valid(@competition, :owner)
  end

  test 'validates that default locale belongs to this competition' do
    @competition.default_locale = locales(:german_open_german)
    assert_not_valid(@competition, :default_locale)
  end

  test '#already_over?' do
    last_day = @competition.days.map(&:date).max

    Timecop.freeze(last_day - 1.week) do
      assert_equal false, @competition.already_over?
    end

    Timecop.freeze(last_day) do
      assert_equal false, @competition.already_over?
    end

    Timecop.freeze(last_day + 1.day) do
      assert_equal true, @competition.already_over?
    end
  end

  [ :entrance_fee_competitors, :entrance_fee_guests ].each do |fee|
    test "validates presence of #{fee}" do
      @competition.send("#{fee}=", nil)
      assert_not_valid(@competition, fee)
    end

    test "validates numericality of #{fee}" do
      @competition.send("#{fee}=", 'foobar')
      assert_not_valid(@competition, fee)

      @competition.send("#{fee}=", 17)
      assert_valid(@competition)

      @competition.send("#{fee}=", 42.17)
      assert_valid(@competition)

      @competition.send("#{fee}=", 0)
      assert_valid(@competition)

      @competition.send("#{fee}=", -10)
      assert_not_valid(@competition, fee)
    end
  end

  test "validates pricing_model is in list" do
    @competition.pricing_model = 'foobar'
    assert_not_valid(@competition, :pricing_model)

    @competition.pricing_model = Competition::PRICING_MODELS.keys.first
    assert_valid(@competition)
  end

  test ".custom_domains" do
    @competition.custom_domain = "foobar.com"
    @competition.save!
    assert_equal({ "foobar.com" => 'http' }, Competition.custom_domains)

    other_competition = competitions(:german_open)
    other_competition.custom_domain = "blabla.de"
    other_competition.custom_domain_force_ssl = true
    other_competition.save!
    assert_equal({ "blabla.de" => 'https', "foobar.com" => 'http' }, Competition.custom_domains)

    other_competition.custom_domain = @competition.custom_domain
    other_competition.custom_domain_force_ssl = true
    other_competition.save!
    assert_equal({ "foobar.com" => 'https' }, Competition.custom_domains)
  end
end
