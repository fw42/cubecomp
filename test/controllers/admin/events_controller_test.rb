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
      name: 'Rubiks Pocket Cube',
      name_short: '2x2x2',
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
      name: 'Rubiks Pocket Cube',
      name_short: '2x2x2',
      length_in_minutes: 60,
      max_number_of_registrations: 42,
      start_time: '15:00',
      state: 'open_for_registration'
    }

    patch :update, competition_id: @competition.id, id: @event.id, event: params

    assert_redirected_to edit_admin_competition_event_path(@competition.id, assigns(:event))
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

  test '#load_day_form' do
    get :load_day_form, competition_id: @competition.id
    assert_response :success
  end

  test '#load_day' do
    to_day = days(:german_open_day_one)
    from_day = days(:aachen_open_day_two)

    competition = to_day.competition
    login_as(competition.users.first)

    assert_difference 'competition.reload.events.count', -to_day.events.count + from_day.events.count do
      post :load_day, competition_id: competition.id, from_day_id: from_day.id, to_day_id: to_day.id
    end

    assert_events_equal from_day.reload.events, to_day.reload.events
    assert_redirected_to admin_competition_events_path(competition)
  end

  test '#load_day does not allow to overwrite another competitions day' do
    assert_no_difference '@competition.reload.events.count' do
      post :load_day,
        competition_id: @competition.id,
        from_day_id: @competition.days.first.id,
        to_day_id: days(:german_open_day_one).id
    end

    assert_response :not_found
  end
end
