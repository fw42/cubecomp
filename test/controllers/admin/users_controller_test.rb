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
    params = {
      email: 'bob@cubecomp.de',
      first_name: 'Bob',
      last_name: 'Bobsen',
      password: 'foobar'
    }

    assert_difference('User.count') do
      post :create, user: params
    end

    assert_redirected_to admin_user_path(assigns(:user))
    user = User.find_by(email: 'bob@cubecomp.de')
    assert_attributes(params.except(:password), user)
    assert user.authenticate(params[:password])
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
    params = {
      email: 'bob@cubecomp.de',
      first_name: 'Bob',
      last_name: 'Bobsen',
      password: 'foobar'
    }

    patch :update, id: @user, user: params

    assert_redirected_to admin_user_path(assigns(:user))
    user = User.find_by(email: 'bob@cubecomp.de')
    assert_attributes(params.except(:password), user)
    assert user.authenticate(params[:password])
  end

  test "#destroy" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to admin_users_path
  end
end
