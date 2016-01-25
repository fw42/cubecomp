require 'test_helper'

class SessionsTest < ActionDispatch::IntegrationTest
  SESSION_KEY = '_cubecomp_session'.freeze

  setup do
    https!
    @user = users(:regular_user_with_no_competitions)
  end

  test 'login requires https' do
    https!(false)
    get '/admin/login'
    assert_redirected_to 'https://www.example.com/admin/login'

    post '/admin/login', user: { email: @user.email, password: 'test' }
    assert_redirected_to 'https://www.example.com/admin/login'
  end

  test 'Session fixation - login resets session' do
    assert_not_logged_in
    old_session_id = cookies[SESSION_KEY]

    login
    assert_logged_in
    new_session_id = cookies[SESSION_KEY]

    assert_not_equal old_session_id, new_session_id, 'session ids should be different'
  end

  test 'Session fixation - logout resets session' do
    login
    assert_logged_in
    old_session_id = cookies[SESSION_KEY]

    logout
    new_session_id = cookies[SESSION_KEY]

    assert_not_equal old_session_id, new_session_id, 'session ids should be different'
  end

  test 'Updating user password invalidates other user sessions' do
    login
    assert_logged_in
    old_session_id = cookies[SESSION_KEY]

    @user.password = 'blablabla'
    @user.password_confirmation = 'blablabla'
    @user.save!

    assert_not_logged_in
    new_session_id = cookies[SESSION_KEY]

    assert_not_equal old_session_id, new_session_id
  end

  test 'Updating user email invalidates other user sessions' do
    login
    assert_logged_in
    old_session_id = cookies[SESSION_KEY]

    @user.email = 'new@email.com'
    @user.save!

    assert_not_logged_in
    new_session_id = cookies[SESSION_KEY]

    assert_not_equal old_session_id, new_session_id
  end

  private

  def logout
    delete '/admin/logout'
    assert_redirected_to admin_login_path
  end

  def login(user = @user)
    get "/admin/login"
    assert_response :success

    post '/admin/login', user: { email: user.email, password: 'test' }
    assert_redirected_to admin_root_path
  end

  def assert_logged_in(user = @user)
    get edit_admin_user_path(user.id)
    assert_response :success
  end

  def assert_not_logged_in(user = @user)
    get edit_admin_user_path(user.id)
    assert_redirected_to admin_login_path
  end
end
