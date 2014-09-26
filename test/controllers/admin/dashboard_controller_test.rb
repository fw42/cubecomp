require 'test_helper'

class Admin::DashboardControllerTest < ActionController::TestCase
  setup do
    @competition = competitions(:aachen_open)
    login_as(@competition.users.first)
  end

  test '#index' do
    get :index, competition_id: @competition.id
    assert_response :ok
  end

  test '#index renders 404 with invalid competition id' do
    get :index, competition_id: 17
    assert_response :not_found
  end
end
