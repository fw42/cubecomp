require 'test_helper'

class EventRegistrationTest < ActiveSupport::TestCase
  setup do
    @registration = event_registrations(:aachen_open_flo_rubiks_cube)
  end

  test 'validates presence and integrity of competition' do
    @registration.competition = nil
    assert_not_valid(@registration, :competition)

    @registration.competition_id = 1234
    assert_not_valid(@registration, :competition)
  end

  test 'validates presence and integrity of event' do
    @registration.event = nil
    assert_not_valid(@registration, :event)

    @registration.event_id = 1234
    assert_not_valid(@registration, :event)
  end

  test 'validates presence and integrity of competitor' do
    @registration.competitor = nil
    assert_not_valid(@registration, :competitor)

    @registration.competitor_id = 1234
    assert_not_valid(@registration, :competitor)
  end

  test 'validates uniqueness of competitor, scoped to event' do
    new_registration = @registration.dup
    assert_not_valid(new_registration, :competitor_id)
  end

  test 'validates integrity of competition ids' do
    @registration.competition = competitions(:german_open)
    assert_not_valid(@registration, :competition_id)
    errors = @registration.errors[:competition_id]
    assert_equal ['does not match event competition_id', 'does not match competitor competition_id'], errors
  end

  test 'validates that competitor is registered for the day of the event' do
    @registration.competitor.day_registrations.delete_all
    assert_not_valid(@registration.reload, :base)
    assert_equal ['competitor is not registered for the day of the event'], @registration.errors[:base]
  end

  test 'validates that event is not not_for_registration' do
    @registration.event.update(state: 'not_for_registration')
    assert_not_valid(@registration, :event)
    assert_not_valid(@registration.event, :state)
  end
end
