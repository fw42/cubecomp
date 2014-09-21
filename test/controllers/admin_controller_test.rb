require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "#index redirects to competition dashboard from session" do
    user = users(:regular_user_with_two_competitions)
    competition = user.competitions.first

    login_as(user)
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
    user.competitions.each(&:destroy!)
    login_as(user)

    get :index
    assert_redirected_to edit_admin_user_path(user.id)
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
