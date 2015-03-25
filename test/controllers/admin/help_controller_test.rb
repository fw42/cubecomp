require 'test_helper'

class Admin::HelpControllerTest < ActionController::TestCase
  setup do
    login_as(users(:admin))
  end

  test "#index" do
    get :index
    assert_response :ok
  end
end
