require 'test_helper'

class Admin::EventsControllerTest < ActionController::TestCase
  setup do
    @event = events(:aachen_open_rubiks_cube)
    @competition = @event.competition
    login_as(@competition.users.first)
  end

  test '#index' do
    get :index, params: { competition_id: @competition.id }
    assert_response :success
  end

  test '#index renders 404 with invalid competition id' do
    get :index, params: { competition_id: 17 }
    assert_response :not_found
  end

  test '#print without parameter' do
    get :print, params: { competition_id: @competition.id }
    assert_response :ok
  end

  test '#print with parameter' do
    day = @competition.days.last
    get :print, params: { competition_id: @competition.id, day_id: day.id }
    assert_response :ok
  end

  test '#new' do
    get :new, params: { competition_id: @competition.id }
    assert_response :success
  end

  test '#create' do
    event_params = {
      day_id: days(:aachen_open_day_one).id,
      handle: '222',
      name: '2x2 cube',
      length_in_minutes: 60,
      max_number_of_registrations: 42,
      start_time: '15:00',
      state: 'open_for_registration'
    }

    assert_difference('@competition.events.count') do
      post :create, params: {
        competition_id: @competition.id,
        event: event_params
      }
    end

    assert_redirected_to admin_competition_events_path(@competition.id)
    event = @competition.events.last
    assert_attributes(event_params.except(:start_time), event)
  end

  test '#edit' do
    get :edit, params: { competition_id: @competition.id, id: @event.id }
    assert_response :success
  end

  test '#update' do
    event_params = {
      day_id: days(:aachen_open_day_two).id,
      handle: '222',
      name: '2x2 cube',
      length_in_minutes: 60,
      max_number_of_registrations: 42,
      start_time: '15:00',
      state: 'open_for_registration'
    }

    patch :update, params: {
      competition_id: @competition.id,
      id: @event.id,
      event: event_params
    }

    assert_redirected_to admin_competition_events_path(@competition.id)
    @event.reload
    assert_attributes(event_params.except(:start_time), @event)
    assert_equal Time.zone.parse(event_params[:start_time]).strftime('%H:%M'), @event.start_time.strftime('%H:%M')
  end

  test '#destroy' do
    assert_difference('@competition.events.count', -1) do
      delete :destroy, params: {
        competition_id: @competition.id,
        id: @event.id
      }
    end

    assert_redirected_to admin_competition_events_path(@competition)
  end

  test '#destroy_day' do
    day = @competition.events.first.day
    count = day.events.count

    assert_difference '@competition.events.count', -count do
      delete :destroy_day, params: {
        competition_id: @competition.id,
        day_id: day.id
      }
    end

    assert_redirected_to admin_competition_events_path(@competition)
  end

  test '#import_day_form' do
    get :import_day_form, params: { competition_id: @competition.id }
    assert_response :success
  end

  test '#import_day' do
    to_day = days(:german_open_day_one)
    from_day = days(:aachen_open_day_two)

    competition = to_day.competition
    login_as(competition.users.first)

    assert_difference 'competition.reload.events.count', -to_day.events.count + from_day.events.count do
      post :import_day, params: {
        competition_id: competition.id,
        from_day_id: from_day.id,
        to_day_id: to_day.id
      }
    end

    assert_events_equal from_day.reload.events, to_day.reload.events
    assert_redirected_to admin_competition_events_path(competition)
    assert_nil flash[:error]
    assert_equal "Events successfully imported.", flash[:notice]
  end

  test '#import_day when one of the events already exist on another day' do
    to_day = days(:german_open_day_one)
    from_day = days(:aachen_open_day_two)

    competition = to_day.competition

    other_day = days(:german_open_day_two)
    duplicate_event_attributes = from_day.events.detect(&:for_registration?).attributes.except("id", "day_id")
    duplicate_event_attributes['competition_id'] = competition.id
    other_day.events.create!(duplicate_event_attributes)

    login_as(competition.users.first)

    assert_no_difference 'competition.reload.events.count' do
      post :import_day, params: {
        competition_id: competition.id,
        from_day_id: from_day.id,
        to_day_id: to_day.id
      }
    end

    assert_redirected_to admin_competition_events_path(competition)
    assert_nil flash[:notice]

    expected_error = "Events handle 4 has already been used by another event" \
      " of this competition that is also for registration"
    assert_equal expected_error, flash[:error]
  end

  test '#import_day does not allow to overwrite another competitions day' do
    assert_no_difference '@competition.reload.events.count' do
      post :import_day, params: {
        competition_id: @competition.id,
        from_day_id: @competition.days.first.id,
        to_day_id: days(:german_open_day_one).id
      }
    end

    assert_response :not_found
  end
end
