require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test '#index redirects to login page if user is not logged in' do
    logout
    get :index
    assert_redirected_to admin_login_path
  end

  test "#index redirects to login page if old user session exists but user doesn't exist anymore" do
    user = users(:regular_user_with_no_competitions)
    login_as(user)
    user.destroy!
    get :index
    assert_redirected_to admin_login_path
  end

  test '#index redirects to dashboard from session' do
    user = users(:regular_user_with_two_competitions)
    login_as(user)

    competition = user.competitions.first
    session[:competition_id] = competition.id

    get :index
    assert_redirected_to admin_competition_dashboard_index_path(competition.id)
  end

  test "#index redirects to users' last competition if it exists and no competition is set in the session" do
    user = users(:regular_user_with_two_competitions)
    login_as(user)

    get :index
    competition = user.competitions.last
    assert_redirected_to admin_competition_dashboard_index_path(competition.id)
  end

  test '#index redirects to user page if user has no competitions' do
    user = users(:regular_user_with_no_competitions)
    login_as(user)
    get :index
    assert_redirected_to edit_admin_user_path(user.id)
  end

  test '#index redirects to user page if user is not allowed to login to any competitions' do
    user = users(:regular_user_with_two_competitions)
    login_as(user)
    UserPolicy.any_instance.expects(:login?).with(anything).at_least_once.returns(false)
    get :index
    assert_redirected_to edit_admin_user_path(user.id)
  end

  test '#index allowed if user can #login? to competition' do
    user = users(:regular_user_with_no_competitions)
    login_as(user)
    competition = Competition.first
    UserPolicy.any_instance.expects(:login?).with(competition).at_least_once.returns(true)
    get :index, competition_id: competition.id
    assert_redirected_to admin_competition_dashboard_index_path(competition.id)
  end

  test '#index renders 403 if user cannot #login? to competition' do
    user = users(:regular_user_with_no_competitions)
    login_as(user)
    competition = Competition.first
    UserPolicy.any_instance.expects(:login?).with(competition).at_least_once.returns(false)
    get :index, competition_id: competition.id
    assert_response :forbidden
  end

  test "#index redirects to last competition if user session has old competition that doesn't exist anymore" do
    user = users(:regular_user_with_two_competitions)
    login_as(user)

    competition = user.competitions.first
    session[:competition_id] = competition.id
    competition.destroy!

    get :index
    competition = user.competitions.last
    assert_redirected_to admin_competition_dashboard_index_path(competition.id)
  end

  test "#index redirects to last competition if user doesn't have permission to competition from session" do
    user = users(:regular_user_with_two_competitions)
    login_as(user)

    competition = user.competitions.first
    session[:competition_id] = competition.id
    user.permissions.where(competition: competition).each(&:destroy!)

    get :index
    competition = user.competitions.last
    assert_redirected_to admin_competition_dashboard_index_path(competition.id)
  end

  test "#index redirects to last competition if user is admin and doesn't have any explicit permissions" do
    user = users(:admin)
    login_as(user)
    user.permissions.each(&:destroy!)
    get :index
    assert_redirected_to admin_competition_dashboard_index_path(Competition.last.id)
  end

  test 'forms contain CSRF tokens' do
    @controller = Admin::UsersController.new
    login_as(users(:regular_user_with_no_competitions))

    with_csrf_protection do
      get :edit, id: users(:regular_user_with_no_competitions).id
      assert_match(/<meta name="csrf-param" content="authenticity_token" \/>/, @response.body)
      assert_match(/<meta name="csrf-token" content="[^"]+" \/>/, @response.body)
    end
  end

  test 'POST fails if CSRF token is missing' do
    @controller = Admin::UsersController.new
    login_as(users(:regular_user_with_no_competitions))

    with_csrf_protection do
      assert_raises ActionController::InvalidAuthenticityToken do
        post :edit, id: users(:regular_user_with_no_competitions), user: {
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
