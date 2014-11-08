require 'test_helper'

class Admin::EventRegistrationsControllerTest < ActionController::TestCase
  setup do
    @registration = event_registrations(:aachen_open_flo_rubiks_cube)
    @event = @registration.event
    @competition = @event.competition
    login_as(@competition.users.first)
  end

  test '#index' do
    get :index, competition_id: @competition.id, event_id: @event.id
    assert_response :success
    assert_not_nil assigns(:event)
    assert_not_nil assigns(:registrations)
  end

  test '#waiting' do
    get :waiting, competition_id: @competition.id
    assert_response :success
    assert_not_nil assigns(:registrations)
  end

  test '#remove_all_waiting' do
    @registration.update_attributes(waiting: true)
    patch :remove_all_waiting, competition_id: @competition.id
    assert_equal false, @registration.reload.waiting
  end

  test '#update_waiting' do
    patch :update_waiting,
      competition_id: @competition.id,
      event_id: @event.id,
      id: @registration.id,
      waiting: 'true'

    assert_equal true, @registration.reload.waiting

    patch :update_waiting,
      competition_id: @competition.id,
      event_id: @event.id,
      id: @registration.id,
      waiting: 'false'

    assert_equal false, @registration.reload.waiting
  end

  test '#destroy' do
    assert_difference 'EventRegistration.count', -1 do
      delete :destroy, competition_id: @competition.id, event_id: @event.id, id: @registration.id
    end
  end
end
