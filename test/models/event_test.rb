require 'test_helper'

class EventTest < ActiveSupport::TestCase
  setup do
    @event = events(:aachen_open_rubiks_cube)
  end

  test 'validates presence and integrity of competition' do
    @event.competition = nil
    assert_not_valid(@event, :competition)

    @event.competition_id = 1234
    assert_not_valid(@event, :competition)
  end

  test 'validates presence and integrity of day' do
    @event.day = nil
    assert_not_valid(@event, :day)

    @event.day_id = 1234
    assert_not_valid(@event, :day)
  end

  test 'validates presence of name' do
    @event.name = nil
    assert_not_valid(@event, :name)

    @event.name = ''
    assert_not_valid(@event, :name)
  end

  test 'validates presence of handle unless not_for_registration' do
    @event.state = 'open_for_registration'

    @event.handle = nil
    assert_not_valid(@event, :handle)

    @event.handle = ''
    assert_not_valid(@event, :handle)

    @event.registrations.each(&:destroy!)
    @event.reload
    @event.state = 'not_for_registration'

    @event.handle = nil
    assert_valid @event

    @event.handle = ''
    assert_valid @event
  end

  test 'validates uniqueness of handle, scoped to competition, if event is for registration' do
    @event.state = 'open_for_registration'

    new_event = @event.dup
    assert_not_valid(new_event, :handle)

    new_event.competition = competitions(:german_open)
    assert_valid new_event
  end

  test 'does not validate uniqueness of handle if event is not for registration' do
    @event.state = 'open_for_registration'
    new_event = @event.dup
    assert_not_valid(new_event, :handle)

    new_event.state = 'not_for_registration'
    assert_valid new_event
  end

  test 'validates presence of start_time' do
    @event.start_time = nil
    assert_not_valid(@event, :start_time)
  end

  test 'does not validate presence of max_number_of_registrations' do
    @event.max_number_of_registrations = nil
    assert_valid @event
  end

  test 'validates numericality of max_number_of_registrations' do
    @event.max_number_of_registrations = 'foobar'
    assert_not_valid(@event, :max_number_of_registrations)

    @event.max_number_of_registrations = 17
    assert_valid @event
  end

  test 'validates presence and inclusion of state' do
    @event.state = nil
    assert_not_valid(@event, :state)

    @event.state = 'foo'
    assert_not_valid(@event, :state)

    @event.state = Event::STATES.keys.first
    assert_valid @event
  end

  test 'does not validate presence of length_in_minutes' do
    @event.length_in_minutes = nil
    assert_valid @event
  end

  test 'validates numericality of length_in_minutes' do
    @event.length_in_minutes = 'foobar'
    assert_not_valid(@event, :length_in_minutes)

    @event.length_in_minutes = 17
    assert_valid @event
  end

  test 'destroying event destroys registrations but not competitors' do
    count = @event.registrations.count
    assert_difference 'EventRegistration.count', -1 * count do
      assert_no_difference 'Competitor.count' do
        @event.destroy
      end
    end
  end

  test 'end_time is sum of start_time and length_in_minutes' do
    @event.length_in_minutes = 17
    assert_equal @event.start_time + 17.minutes, @event.end_time
  end

  test 'end_time if length_in_minutes is nil' do
    @event.length_in_minutes = nil
    assert_nil @event.end_time
  end

  test '.with_max_number_of_registrations' do
    competition = competitions(:aachen_open)
    events = competition.events.with_max_number_of_registrations.to_a

    assert_not_equal 0, events.size
    assert events.all?{ |event| event.max_number_of_registrations >= 0 }
    assert_not_nil events.first.number_of_confirmed_registrations
  end

  test "#wca_handle returns wca handle that matches the given short handle" do
    event = Event.new
    event.handle = '3'
    assert_equal '333', event.wca_handle
  end

  test "#wca_handle returns wca handle if handle itself is already a wca handle" do
    event = Event.new
    event.handle = '333'
    assert_equal '333', event.wca_handle
  end

  test "#wca_handle returns nil if handle is unknown" do
    event = Event.new
    event.handle = 'foobar'
    assert_nil event.wca_handle
  end

  test ".wca returns all events that have a valid wca handle or a handle that can be mapped to a wca handle" do
    competition = competitions(:aachen_open)
    events = competition.events.wca
    assert_equal %w(333 444 555), events.map(&:wca_handle)

    events.first.update_attributes(handle: "333")
    events = competition.events.wca
    assert_equal %w(333 444 555), events.map(&:wca_handle)

    events.first.update_attributes(handle: "foobar")
    events = competition.events.wca
    assert_equal %w(444 555), events.map(&:wca_handle)
  end
end
