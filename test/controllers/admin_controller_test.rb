require 'test_helper'

class AdminControllerTest < ActionController::TestCase
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
