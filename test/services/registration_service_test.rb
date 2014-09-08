require 'test_helper'

class RegistrationServiceTest < ActiveSupport::TestCase
  setup do
    @competitor = competitors(:aachen_open_with_no_registrations)
    @competition = @competitor.competition
  end

  test "#register_for_day" do
    assert_difference '@competitor.day_registrations.count', 1 do
      assert_no_difference 'EventRegistration.count' do
        RegistrationService.new(@competitor).register_for_day!(@competition.days.first)
      end
    end
  end

  test "#register_for_event if not already regsitered for day" do
    assert_difference '@competitor.day_registrations.count', 1 do
      assert_difference '@competitor.event_registrations.count', 1 do
        RegistrationService.new(@competitor).register_for_event!(@competition.events.first)
      end
    end
  end

  test "#register_for_event if already registered for day" do
    service = RegistrationService.new(@competitor)
    service.register_for_day!(@competition.days.first)

    assert_no_difference '@competitor.day_registrations.count' do
      assert_difference '@competitor.event_registrations.count', 1 do
        service.register_for_event!(@competition.events.first)
      end
    end
  end
end
