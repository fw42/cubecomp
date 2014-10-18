require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  setup do
    login_as(users(:admin))
    @user = users(:flo)
  end

  test '#index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test '#new' do
    get :new
    assert_response :success
  end

  test '#create' do
    params = {
      email: 'bob@cubecomp.de',
      first_name: 'Bob',
      last_name: 'Bobsen',
      password: 'foobar',
      password_confirmation: 'foobar',
      permission_level: User::PERMISSION_LEVELS.values.min,
      address: 'Foo Bar 1, 123 Foo, Germany'
    }

    assert_difference('User.count') do
      post :create, user: params
    end

    assert_redirected_to edit_admin_user_path(assigns(:user))
    user = User.find_by(email: 'bob@cubecomp.de')
    assert_attributes(params.except(:password, :password_confirmation), user)
    assert user.authenticate(params[:password])
  end

  test '#edit on another user is not possible if not logged in as super admin' do
    # TODO
  end

  test '#edit on another user is possible if logged in as super admin' do
    # TODO
  end

  test '#edit' do
    get :edit, id: @user
    assert_response :success
  end

  test '#edit renders 404 with invalid competition id' do
    get :edit, id: 17
    assert_response :not_found
  end

  test '#update' do
    params = {
      email: 'bob@cubecomp.de',
      first_name: 'Bob',
      last_name: 'Bobsen',
      password: 'foobar',
      password_confirmation: 'foobar',
      address: 'Foo Bar 1, 123 Foo, Germany'
    }

    patch :update, id: @user, user: params

    assert assigns(:user)
    assert_redirected_to edit_admin_user_path(assigns(:user))
    user = User.find_by(email: 'bob@cubecomp.de')
    assert_attributes(params.except(:password, :password_confirmation), user)
    assert user.authenticate(params[:password])
  end

  test "#update when passwords don't match fails" do
    patch :update, id: @user, user: { password: 'foo', password_confirmation: 'bar' }
    assert_response 200
    assert_equal ["doesn't match Password"], assigns(:user).errors[:password_confirmation]
    refute @user.reload.authenticate(:foo)
  end

  test '#update with blank password fields doesnt change password' do
    patch :update, id: @user, user: { password: '', password_confirmation: '' }
    @user.reload
    assert @user.authenticate('test')
  end

  test '#destroy' do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to admin_users_path
  end
end
