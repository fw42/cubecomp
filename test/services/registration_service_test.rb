require 'test_helper'

class RegistrationServiceTest < ActiveSupport::TestCase
  setup do
    @competitor = competitors(:aachen_open_day_one_guest)
    @new_day = days(:aachen_open_day_two)
    @competition = @competitor.competition
    @service = RegistrationService.new(@competitor)
  end

  test '#register_for_day' do
    assert_difference '@competitor.day_registrations.count', 1 do
      assert_no_difference 'EventRegistration.count' do
        @service.register_for_day(@new_day.id)
        @competitor.save!
      end
    end

    assert_no_difference 'DayRegistration.count' do
      @service.register_for_day(@new_day.id)
      @competitor.save!
    end
  end

  test '#unregister_from_day' do
    registration = day_registrations(:flo_aachen_open_day_one)
    competitor = registration.competitor
    RegistrationService.new(competitor).register_as_guest(days(:aachen_open_day_two).id)
    competitor.save!

    event_count = competitor.events.select{ |event| event.day == registration.day }.count

    assert_difference 'competitor.day_registrations.count', -1 do
      assert_difference 'competitor.event_registrations.count', -1 * event_count do
        RegistrationService.new(competitor).unregister_from_day(registration.day_id)
        competitor.save!
      end
    end

    assert_no_difference 'competitor.day_registrations.count' do
      assert_no_difference 'competitor.event_registrations.count' do
        RegistrationService.new(competitor).unregister_from_day(registration.day_id)
        competitor.save!
      end
    end
  end

  test '#register_for_event if not already regsitered for day' do
    assert_difference '@competitor.day_registrations.count', 1 do
      assert_difference '@competitor.event_registrations.count', 1 do
        @service.register_for_event(events(:aachen_open_rubiks_revenge_day_two))
        @competitor.save!
      end
    end
  end

  test '#register_for_event if already registered for day' do
    event = @competition.events.first
    @service.register_for_day(event.day_id)
    @competitor.save!

    assert_no_difference '@competitor.day_registrations.count' do
      assert_difference '@competitor.event_registrations.count', 1 do
        @service.register_for_event(event)
        @competitor.save!
      end
    end
  end

  test '#register_for_event that is already closed requires admin flag' do
    event = @competition.events.first
    event.update(state: 'registration_closed')

    assert_no_difference '@competitor.event_registrations.size' do
      assert_raises RegistrationService::PermissionError do
        @service.register_for_event(event)
      end
    end

    assert_difference '@competitor.event_registrations.size', +1 do
      assert_nothing_raised do
        RegistrationService.new(@competitor, admin: true).register_for_event(event)
      end
    end
  end

  test '#register_for_event that is on waiting requires admin flag' do
    event = @competition.events.first
    event.update(state: 'open_with_waiting_list')

    assert_no_difference '@competitor.event_registrations.size' do
      assert_raises RegistrationService::PermissionError do
        @service.register_for_event(event)
      end
    end

    assert_difference '@competitor.event_registrations.size', +1 do
      assert_nothing_raised do
        RegistrationService.new(@competitor, admin: true).register_for_event(event)
      end
    end
  end

  test '#register_as_guest if not already registered for day' do
    day = days(:aachen_open_day_two)
    assert_difference '@competitor.day_registrations.count', +1 do
      assert_no_difference '@competitor.event_registrations.count' do
        @service.register_for_day(day.id)
        @competitor.save!
      end
    end
    assert @competitor.guest_on?(day)

    assert_no_difference '@competitor.day_registrations.count' do
      @service.register_for_day(day.id)
      @competitor.save!
    end
  end

  test '#register_as_guest if already registered for day as competitor' do
    event_registration = event_registrations(:aachen_open_flo_rubiks_cube)
    competitor = event_registration.competitor
    day = event_registration.event.day
    service = RegistrationService.new(competitor)
    count = competitor.event_registrations.count

    assert_difference 'competitor.event_registrations.count', -1 * count do
      assert_no_difference 'DayRegistration.count' do
        service.register_as_guest(day.id)
        competitor.save!
      end
    end

    assert competitor.guest_on?(day)
  end

  test '#unregister_from_event' do
    event_registration = event_registrations(:aachen_open_flo_rubiks_cube)
    competitor = event_registration.competitor
    service = RegistrationService.new(competitor)

    assert_difference 'competitor.event_registrations.count', -1 do
      assert_no_difference 'DayRegistration.count' do
        service.unregister_from_event(event_registration.event_id)
        competitor.save!
      end
    end
  end

  test '#unregister_from_event if not registered' do
    assert_no_difference 'EventRegistration.count' do
      assert_no_difference 'DayRegistration.count' do
        @service.unregister_from_event(Event.first)
        @competitor.save!
      end
    end
  end
end
