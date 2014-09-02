require 'test_helper'

class EventTest < ActiveSupport::TestCase
  setup do
    @event = events(:aachen_open_rubiks_cube)
  end

  test "validates presence and integrity of competition" do
    @event.competition = nil
    assert_not_valid(@event, :competition)

    @event.competition_id = 1234
    assert_not_valid(@event, :competition)
  end

  test "validates presence and integrity of day" do
    @event.day = nil
    assert_not_valid(@event, :day)

    @event.day_id = 1234
    assert_not_valid(@event, :day)
  end

  test "validates presence of name_short" do
    @event.name_short = nil
    assert_not_valid(@event, :name_short)

    @event.name_short = ''
    assert_not_valid(@event, :name_short)
  end

  test "validates presence of name_long" do
    @event.name_long = nil
    assert_not_valid(@event, :name_long)

    @event.name_long = ''
    assert_not_valid(@event, :name_long)
  end

  test "validates presence of handle unless not_for_registration" do
    @event.state = 'open_for_registration'

    @event.handle = nil
    assert_not_valid(@event, :handle)

    @event.handle = ''
    assert_not_valid(@event, :handle)

    @event.state = 'not_for_registration'

    @event.handle = nil
    assert_valid @event

    @event.handle = ''
    assert_valid @event
  end

  test "validates uniqueness of handle, scoped to competition" do
    new_event = @event.dup
    assert_not_valid(new_event, :handle)

    new_event.competition = competitions(:german_open)
    assert_valid new_event
  end

  test "validates presence of start_time" do
    @event.start_time = nil
    assert_not_valid(@event, :start_time)
  end

  test "does not validate presence of max_number_of_registrations" do
    @event.max_number_of_registrations = nil
    assert_valid @event
  end

  test "validates numericality of max_number_of_registrations" do
    @event.max_number_of_registrations = 'foobar'
    assert_not_valid(@event, :max_number_of_registrations)

    @event.max_number_of_registrations = 17
    assert_valid @event
  end

  test "validates presence and inclusion of state" do
    @event.state = nil
    assert_not_valid(@event, :state)

    @event.state = 'foo'
    assert_not_valid(@event, :state)

    @event.state = Event::STATES.first
    assert_valid @event
  end

  test "does not validate presence of length_in_minutes" do
    @event.length_in_minutes = nil
    assert_valid @event
  end

  test "validates numericality of length_in_minutes" do
    @event.length_in_minutes = 'foobar'
    assert_not_valid(@event, :length_in_minutes)

    @event.length_in_minutes = 17
    assert_valid @event
  end

  test "destroying event destroys event_registrations but not competitors" do
    count = @event.event_registrations.count
    assert_difference "EventRegistration.count", -1 * count do
      assert_no_difference "Competitor.count" do
        @event.destroy
      end
    end
  end
end
