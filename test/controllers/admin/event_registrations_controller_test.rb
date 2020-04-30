require 'test_helper'

class Admin::EventRegistrationsControllerTest < ActionController::TestCase
  setup do
    @registration = event_registrations(:aachen_open_flo_rubiks_cube)
    @event = @registration.event
    @competition = @event.competition
    login_as(@competition.users.first)
  end

  test '#index' do
    get :index, params: { competition_id: @competition.id, event_id: @event.id }
    assert_response :success
  end

  test '#waiting' do
    get :waiting, params: { competition_id: @competition.id }
    assert_response :success
  end

  test '#remove_all_waiting' do
    @registration.update(waiting: true)
    patch :remove_all_waiting, params: { competition_id: @competition.id }
    assert_equal false, @registration.reload.waiting
  end

  test '#update_waiting' do
    patch :update_waiting, params: {
      competition_id: @competition.id,
      event_id: @event.id,
      id: @registration.id,
      waiting: 'true'
    }

    assert_equal true, @registration.reload.waiting

    patch :update_waiting, params: {
      competition_id: @competition.id,
      event_id: @event.id,
      id: @registration.id,
      waiting: 'false'
    }

    assert_equal false, @registration.reload.waiting
  end

  test '#destroy' do
    assert_difference 'EventRegistration.count', -1 do
      delete :destroy, params: {
        competition_id: @competition.id,
        event_id: @event.id,
        id: @registration.id
      }
    end
  end
end
