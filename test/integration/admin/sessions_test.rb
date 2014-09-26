require 'test_helper'

class SessionsTest < ActionDispatch::IntegrationTest
  SESSION_KEY = '_cubecomp_session'

  test 'Session fixation - login resets session' do
    session_ids = []

    get '/admin'
    assert_response :redirect
    session_ids << cookies[SESSION_KEY]

    user = users(:regular_user_with_no_competitions)
    post '/admin/login', user: { email: user.email, password: 'test' }
    assert_response :redirect
    session_ids << cookies[SESSION_KEY]

    other_user = users(:flo)
    post '/admin/login', user: { email: other_user.email, password: 'test' }
    assert_response :redirect
    session_ids << cookies[SESSION_KEY]

    assert_equal session_ids, session_ids.uniq, 'session ids should be different each time'
  end

  test 'Session fixation - logout resets session' do
    user = users(:regular_user_with_no_competitions)
    post '/admin/login', user: { email: user.email, password: 'test' }
    assert_response :redirect
    old_session_id = cookies[SESSION_KEY]

    delete '/admin/logout'
    assert_response :redirect
    new_session_id = cookies[SESSION_KEY]

    assert_not_equal old_session_id, new_session_id, 'session ids should be different'
  end
end
