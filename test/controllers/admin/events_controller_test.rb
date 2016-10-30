require 'test_helper'

class Admin::EventsControllerTest < ActionController::TestCase
  setup do
    @event = events(:aachen_open_rubiks_cube)
    @competition = @event.competition
    login_as(@competition.users.first)
  end

  test '#index' do
    get :index, competition_id: @competition.id
    assert_response :success
    assert_not_nil assigns(:events)
  end

  test '#index renders 404 with invalid competition id' do
    get :index, competition_id: 17
    assert_response :not_found
  end

  test '#print without parameter renders first day' do
    get :print, competition_id: @competition.id
    assert_response :ok
    assert_equal @competition.days.first, assigns(:day)
  end

  test '#print with parameter renders that day' do
    day = @competition.days.last
    get :print, competition_id: @competition.id, day_id: day.id
    assert_response :ok
    assert_equal day, assigns(:day)
  end

  test '#new' do
    get :new, competition_id: @competition.id
    assert_response :success
  end

  test '#create' do
    params = {
      day_id: days(:aachen_open_day_one).id,
      handle: '222',
      name: '2x2 cube',
      length_in_minutes: 60,
      max_number_of_registrations: 42,
      start_time: '15:00',
      state: 'open_for_registration'
    }

    assert_difference('@competition.events.count') do
      post :create, competition_id: @competition.id, event: params
    end

    assert_redirected_to admin_competition_events_path(@competition.id)
    event = @competition.events.last
    assert_attributes(params.except(:start_time), event)
  end

  test '#edit' do
    get :edit, competition_id: @competition.id, id: @event.id
    assert_response :success
  end

  test '#update' do
    params = {
      day_id: days(:aachen_open_day_two).id,
      handle: '222',
      name: '2x2 cube',
      length_in_minutes: 60,
      max_number_of_registrations: 42,
      start_time: '15:00',
      state: 'open_for_registration'
    }

    patch :update, competition_id: @competition.id, id: @event.id, event: params

    assert_redirected_to admin_competition_events_path(@competition.id)
    @event.reload
    assert_attributes(params.except(:start_time), @event)
    assert_equal Time.zone.parse(params[:start_time]).strftime('%H:%M'), @event.start_time.strftime('%H:%M')
  end

  test '#destroy' do
    assert_difference('@competition.events.count', -1) do
      delete :destroy, competition_id: @competition.id, id: @event.id
    end

    assert_redirected_to admin_competition_events_path(@competition)
  end

  test '#destroy_day' do
    day = @competition.events.first.day
    count = day.events.count

    assert_difference '@competition.events.count', -count do
      delete :destroy_day, competition_id: @competition.id, day_id: day.id
    end

    assert_redirected_to admin_competition_events_path(@competition)
  end

  test '#import_day_form' do
    get :import_day_form, competition_id: @competition.id
    assert_response :success
  end

  test '#import_day' do
    to_day = days(:german_open_day_one)
    from_day = days(:aachen_open_day_two)

    competition = to_day.competition
    login_as(competition.users.first)

    assert_difference 'competition.reload.events.count', -to_day.events.count + from_day.events.count do
      post :import_day, competition_id: competition.id, from_day_id: from_day.id, to_day_id: to_day.id
    end

    assert_events_equal from_day.reload.events, to_day.reload.events
    assert_redirected_to admin_competition_events_path(competition)
    assert_equal nil, flash[:error]
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
      post :import_day, competition_id: competition.id, from_day_id: from_day.id, to_day_id: to_day.id
    end

    assert_redirected_to admin_competition_events_path(competition)
    assert_equal nil, flash[:notice]

    expected_error = "Events handle 4 has already been used by another event" \
      " of this competition that is also for registration"
    assert_equal expected_error, flash[:error]
  end

  test '#import_day does not allow to overwrite another competitions day' do
    assert_no_difference '@competition.reload.events.count' do
      post :import_day,
        competition_id: @competition.id,
        from_day_id: @competition.days.first.id,
        to_day_id: days(:german_open_day_one).id
    end

    assert_response :not_found
  end
end
