require 'test_helper'

class Admin::LoginControllerTest < ActionController::TestCase
  test "#index page" do
    get :index
    assert_template 'admin_empty'
    assert_template 'login/index'
    assert_response :ok
  end

  test "#logout clears session and redirects to login page" do
    login_as(users(:regular_user))
    get :logout
    assert session.empty?
  end

  test "#login with invalid email address renders form with error and status 401" do
    post :login, user: { email: "invalid@invalid.com", password: "foobar" }
    assert_login_failed
  end

  test "#login with valid email address but invalid password doesn't log user in but renders form with error and status 401" do
    user = users(:regular_user)
    post :login, user: { email: user.email, password: "foobar" }
    assert_login_failed
  end

  test "#login with valid credentials logs user in and redirects to admin" do
    user = users(:regular_user)
    post :login, user: { email: user.email, password: "test" }
    assert_equal user.id, session[:user_id]
    assert_redirected_to admin_root_path
  end

  private

  def assert_login_failed
    assert_equal 'Login failed.', flash[:error]
    assert session.to_hash.tap{ |s| s.delete('flash') }.empty?
    assert_response 401
    assert_template 'admin_empty'
    assert_template 'login/index'
  end
end
