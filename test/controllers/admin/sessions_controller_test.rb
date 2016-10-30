require 'test_helper'

class Admin::SessionsControllerTest < ActionController::TestCase
  setup do
    use_https
  end

  test '#new page' do
    get :new
    assert_response :ok
  end

  test '#destroy clears session and redirects to login page' do
    login_as(users(:regular_user_with_no_competitions))
    get :destroy
    assert session.empty?
  end

  test '#create with invalid email address renders form with error and status 401' do
    post :create, params: {
      user: {
        email: 'invalid@invalid.com',
        password: 'foobar'
      }
    }

    assert_login_failed
  end

  test "#create with valid email but invalid password doesn't log user in" do
    user = users(:regular_user_with_no_competitions)

    post :create, params: {
      user: {
        email: user.email,
        password: 'foobar'
      }
    }

    assert_login_failed
  end

  test '#create with valid credentials logs user in and redirects to admin' do
    user = users(:regular_user_with_no_competitions)

    post :create, params: {
      user: {
        email: user.email,
        password: 'test'
      }
    }

    assert_equal user.id, session[:user]['id']
    assert_equal user.version, session[:user]['version']
    assert_redirected_to admin_root_path
  end

  test '#create with valid credentials doesnt log user in if the account is inactive' do
    user = users(:regular_user_with_no_competitions)
    user.update_attributes(active: false)

    post :create, params: {
      user: {
        email: user.email,
        password: 'test'
      }
    }

    assert_login_failed
  end

  private

  def assert_login_failed
    assert_equal 'Login failed.', flash[:error]
    assert session.to_hash.tap{ |s| s.delete('flash') }.empty?
    assert_response 401
  end
end
