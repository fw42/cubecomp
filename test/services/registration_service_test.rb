require 'test_helper'

class RegistrationServiceTest < ActiveSupport::TestCase
  setup do
    @competitor = competitors(:aachen_open_with_no_registrations)
    @competition = @competitor.competition
    @service = RegistrationService.new(@competitor)
  end

  test '#register_for_day!' do
    assert_difference '@competitor.day_registrations.count', 1 do
      assert_no_difference 'EventRegistration.count' do
        @service.register_for_day!(@competition.days.first)
      end
    end

    assert_no_difference 'DayRegistration.count' do
      @service.register_for_day!(@competition.days.first)
    end
  end

  test '#unregister_from_day!' do
    registration = day_registrations(:flo_aachen_open_day_one)
    competitor = registration.competitor
    event_count = competitor.events.select{ |event| event.day == registration.day }.count

    assert_difference 'competitor.day_registrations.count', -1 do
      assert_difference 'competitor.event_registrations.count', -1 * event_count do
        RegistrationService.new(competitor).unregister_from_day!(registration.day)
      end
    end

    assert_no_difference 'competitor.day_registrations.count' do
      assert_no_difference 'competitor.event_registrations.count' do
        RegistrationService.new(competitor).unregister_from_day!(registration.day)
      end
    end
  end

  test '#register_for_event! if not already regsitered for day' do
    assert_difference '@competitor.day_registrations.count', 1 do
      assert_difference '@competitor.event_registrations.count', 1 do
        @service.register_for_event!(@competition.events.first)
      end
    end
  end

  test '#register_for_event! if already registered for day' do
    service = RegistrationService.new(@competitor)
    service.register_for_day!(@competition.days.first)

    assert_no_difference '@competitor.day_registrations.count' do
      assert_difference '@competitor.event_registrations.count', 1 do
        service.register_for_event!(@competition.events.first)
      end
    end
  end

  test '#register_as_guest! if not already registered for day' do
    day = days(:aachen_open_day_one)
    assert_difference '@competitor.day_registrations.count', +1 do
      assert_no_difference '@competitor.event_registrations.count' do
        @service.register_for_day!(day)
      end
    end
    assert @competitor.guest_on?(day)

    assert_no_difference '@competitor.day_registrations.count' do
      @service.register_for_day!(day)
    end
  end

  test '#register_as_guest! if already registered for day as competitor' do
    event_registration = event_registrations(:aachen_open_flo_rubiks_cube)
    competitor = event_registration.competitor
    day = event_registration.event.day
    service = RegistrationService.new(competitor)
    count = competitor.event_registrations.count

    assert_difference 'competitor.event_registrations.count', -1 * count do
      assert_no_difference 'DayRegistration.count' do
        service.register_as_guest!(day)
      end
    end

    assert competitor.guest_on?(day)
  end

  test '#unregister_from_event!' do
    event_registration = event_registrations(:aachen_open_flo_rubiks_cube)
    competitor = event_registration.competitor
    service = RegistrationService.new(competitor)

    assert_difference 'competitor.event_registrations.count', -1 do
      assert_no_difference 'DayRegistration.count' do
        service.unregister_from_event!(event_registration.event)
      end
    end
  end

  test '#unregister_from_event! if not registered' do
    assert_no_difference 'EventRegistration.count' do
      assert_no_difference 'DayRegistration.count' do
        @service.unregister_from_event!(Event.first)
      end
    end
  end
end
