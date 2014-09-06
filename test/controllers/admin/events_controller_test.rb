require 'test_helper'

class Admin::EventsControllerTest < ActionController::TestCase
  setup do
    @event = events(:aachen_open_rubiks_cube)
    @competition = @event.competition
  end

  test "#index" do
    get :index, competition_id: @competition.id
    assert_response :success
    assert_not_nil assigns(:events)
  end

  test "#new" do
    get :new, competition_id: @competition.id
    assert_response :success
  end

  test "#create" do
    params = {
      day_id: days(:aachen_open_day_one).id,
      handle: '444',
      name: 'Rubiks Revenge',
      name_short: '4x4x4',
      length_in_minutes: 60,
      max_number_of_registrations: 42,
      start_time: '15:00',
      state: 'open_for_registration'
    }

    assert_difference('@competition.events.count') do
      post :create, competition_id: @competition.id, event: params
    end

    assert_redirected_to admin_event_path(assigns(:event))
    event = @competition.events.last
    assert_attributes(params.except(:start_time), event)
  end

  test "#show" do
    get :show, id: @event
    assert_response :success
  end

  test "#get" do
    get :edit, id: @event
    assert_response :success
  end

  test "#update" do
    params = {
      day_id: days(:aachen_open_day_two).id,
      handle: '444',
      name: 'Rubiks Revenge',
      name_short: '4x4x4',
      length_in_minutes: 60,
      max_number_of_registrations: 42,
      start_time: '15:00',
      state: 'open_for_registration'
    }

    patch :update, id: @event, event: params

    assert_redirected_to admin_event_path(assigns(:event))
    @event.reload
    assert_attributes(params.except(:start_time), @event)
    assert_equal Time.parse(params[:start_time]).utc.strftime("%H:%M"), @event.start_time.strftime("%H:%M")
  end

  test "#destroy" do
    assert_difference('@competition.events.count', -1) do
      delete :destroy, id: @event
    end

    assert_redirected_to admin_competition_events_path(@competition)
  end
end
