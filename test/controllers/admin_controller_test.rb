require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "#index redirects to login page if user is not logged in" do
    logout
    get :index
    assert_redirected_to admin_login_path
  end

  test "#index redirects to login page if old user session exists but user doesn't exist anymore" do
    user = users(:regular_user)
    login_as(user)
    user.destroy!
    get :index
    assert_redirected_to admin_login_path
  end

  test "#index redirects to competition dashboard from session" do
    user = users(:regular_user_with_two_competitions)
    login_as(user)

    competition = user.competitions.first
    session[:competition_id] = competition.id

    get :index
    assert_redirected_to admin_competition_dashboard_index_path(competition.id)
  end

  test "#index redirects to users' last competition if it exists" do
    user = users(:regular_user_with_two_competitions)
    login_as(user)

    get :index
    competition = user.competitions.last
    assert_redirected_to admin_competition_dashboard_index_path(competition.id)
  end

  test "#index redirects to user page if user has no competitions" do
    user = users(:regular_user)
    login_as(user)

    user.competitions.each(&:destroy!)

    get :index
    assert_redirected_to edit_admin_user_path(user.id)
  end

  test "#index redirects to last competition if user session has old competition but competition doesn't exist anymore" do
    user = users(:regular_user_with_two_competitions)
    login_as(user)

    competition = user.competitions.first
    session[:competition_id] = competition.id
    competition.destroy!

    get :index
    competition = user.competitions.last
    assert_redirected_to admin_competition_dashboard_index_path(competition.id)
  end

  test "#index renders 401 if user session has old competition but user doesn't have permission anymore" do
    user = users(:regular_user_with_two_competitions)
    login_as(user)

    competition = user.competitions.first
    session[:competition_id] = competition.id
    user.permissions.where(competition: competition).each(&:destroy!)

    get :index
    assert_response :unauthorized
  end

  test "#index redirects to user page if user session has competition that doesn't exist anymore and user doesn't have any other competitions" do
    user = users(:regular_user_with_two_competitions)
    login_as(user)

    competition = user.competitions.first
    session[:competition_id] = competition.id
    user.competitions.each(&:destroy!)

    get :index
    assert_redirected_to edit_admin_user_path(user.id)
  end

  test "#index redirects to last competition if user is admin and doesn't have any explicit permissions" do
    user = users(:admin)
    login_as(user)
    user.permissions.each(&:destroy!)
    get :index
    assert_redirected_to admin_competition_dashboard_index_path(Competition.last.id)
  end

  test "forms contain CSRF tokens" do
    @controller = Admin::UsersController.new
    login_as(users(:regular_user))

    with_csrf_protection do
      get :edit, id: users(:regular_user)
      assert_match /<meta content="authenticity_token" name="csrf-param" \/>/, @response.body
      assert_match /<meta content="[^"]+" name="csrf-token" \/>/, @response.body
    end
  end

  test "POST fails if CSRF token is missing" do
    @controller = Admin::UsersController.new
    login_as(users(:regular_user))

    with_csrf_protection do
      assert_raises ActionController::InvalidAuthenticityToken do
        post :edit, id: users(:regular_user), user: {
          permission_level: User::PERMISSION_LEVELS.values.max
        }
      end
    end
  end

  private

  def with_csrf_protection
    old_csrf_value = ActionController::Base.allow_forgery_protection
    ActionController::Base.allow_forgery_protection = true
    yield
  ensure
    ActionController::Base.allow_forgery_protection = old_csrf_value
  end
end
