require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:flo)
  end

  test "#index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "#new" do
    get :new
    assert_response :success
  end

  test "#create" do
    assert_difference('User.count') do
      post :create, user: {
        email: 'bob@cubecomp.de',
        first_name: 'Bob',
        last_name: 'Bobsen',
        password: 'foobar'
      }
    end

    assert_redirected_to admin_user_path(assigns(:user))
    user = User.find_by(email: 'bob@cubecomp.de')
    assert_equal 'Bob', user.first_name
    assert_equal 'Bobsen', user.last_name
    assert user.authenticate('foobar')
  end

  test "#show" do
    get :show, id: @user
    assert_response :success
  end

  test "#edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "#update" do
    patch :update, id: @user, user: {
      email: 'bob@cubecomp.de',
      first_name: 'Bob',
      last_name: 'Bobsen',
      password: 'foobar'
    }

    assert_redirected_to admin_user_path(assigns(:user))
    user = User.find_by(email: 'bob@cubecomp.de')
    assert_equal 'Bob', user.first_name
    assert_equal 'Bobsen', user.last_name
    assert user.authenticate('foobar')
  end

  test "#destroy" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to admin_users_path
  end
end
