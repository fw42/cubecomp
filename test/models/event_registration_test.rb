require 'test_helper'

class EventRegistrationTest < ActiveSupport::TestCase
  setup do
    @registration = event_registrations(:aachen_open_flo_rubiks_cube)
  end

  test "validates presence and integrity of competition" do
    @registration.competition = nil
    assert_not_valid(@registration, :competition)

    @registration.competition_id = 1234
    assert_not_valid(@registration, :competition)
  end

  test "validates presence and integrity of event" do
    @registration.event = nil
    assert_not_valid(@registration, :event)

    @registration.event_id = 1234
    assert_not_valid(@registration, :event)
  end

  test "validates presence and integrity of competitor" do
    @registration.competitor = nil
    assert_not_valid(@registration, :competitor)

    @registration.competitor_id = 1234
    assert_not_valid(@registration, :competitor)
  end

  test "validates uniqueness of competitor, scoped to event" do
    new_registration = @registration.dup
    assert_not_valid(new_registration, :competitor)
  end

  test "validates that competitor is registered for the day of the event" do
    @registration.competitor.day_registrations.delete_all
    assert_not_valid(@registration.reload, :base)
    assert_equal ["competitor is not registered for the day of the event"], @registration.errors[:base]
  end
end
