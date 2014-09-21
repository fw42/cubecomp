require 'test_helper'

class Admin::SessionsControllerTest < ActionController::TestCase
  test "#new page" do
    get :new
    assert_template 'admin_empty'
    assert_template 'sessions/new'
    assert_response :ok
  end

  test "#destroy clears session and redirects to login page" do
    login_as(users(:regular_user_with_no_competitions))
    get :destroy
    assert session.empty?
  end

  test "#create with invalid email address renders form with error and status 401" do
    post :create, user: { email: "invalid@invalid.com", password: "foobar" }
    assert_login_failed
  end

  test "#create with valid email address but invalid password doesn't log user in but renders form with error and status 401" do
    user = users(:regular_user_with_no_competitions)
    post :create, user: { email: user.email, password: "foobar" }
    assert_login_failed
  end

  test "#create with valid credentials logs user in and redirects to admin" do
    user = users(:regular_user_with_no_competitions)
    post :create, user: { email: user.email, password: "test" }
    assert_equal user.id, session[:user_id]
    assert_redirected_to admin_root_path
  end

  private

  def assert_login_failed
    assert_equal 'Login failed.', flash[:error]
    assert session.to_hash.tap{ |s| s.delete('flash') }.empty?
    assert_response 401
    assert_template 'admin_empty'
    assert_template 'sessions/new'
  end
end
