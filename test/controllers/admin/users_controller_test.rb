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
      password: 'foobar',
      password_confirmation: 'foobar'
    }

    assert_difference('User.count') do
      post :create, user: params
    end

    assert_redirected_to admin_user_path(assigns(:user))
    user = User.find_by(email: 'bob@cubecomp.de')
    assert_attributes(params.except(:password, :password_confirmation), user)
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
      password: 'foobar',
      password_confirmation: 'foobar'
    }

    patch :update, id: @user, user: params

    assert_redirected_to admin_user_path(assigns(:user))
    user = User.find_by(email: 'bob@cubecomp.de')
    assert_attributes(params.except(:password, :password_confirmation), user)
    assert user.authenticate(params[:password])
  end

  test "#update when passwords dont match fails" do
    patch :update, id: @user, user: { password: 'foo', password_confirmation: 'bar' }
    assert_response 200
    assert_equal ["doesn't match Password"], assigns(:user).errors[:password_confirmation]
    refute @user.reload.authenticate(:foo)
  end

  test "#update super admin flag is possible if logged in as super admin" do
    login_as(users(:admin))
    regular_user = users(:regular_user)
    patch :update, id: regular_user, user: { super_admin: true }
    assert_equal true, regular_user.reload.super_admin
  end

  test "#update super admin flag is not possible if not logged in as super admin" do
    login_as(users(:regular_user))
    patch :update, id: @user, user: { super_admin: false }
    refute @user.reload.super_admin
  end

  test "#update delegate flag is possible if logged in as super admin" do
    login_as(users(:admin))
    regular_user = users(:regular_user)
    patch :update, id: regular_user, user: { delegate: true }
    assert_equal true, regular_user.reload.delegate
  end

  test "#update delegate flag is not possible if not logged in as super admin" do
    login_as(users(:regular_user))
    delegate = users(:delegate)
    patch :update, id: delegate, user: { delegate: false }
    assert_equal true, delegate.reload.delegate
  end

  test "#update with blank password fields doesnt change password" do
    patch :update, id: @user, user: { password: "", password_confirmation: "" }
    @user.reload
    assert @user.authenticate('test')
  end

  test "#destroy" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to admin_users_path
  end
end
