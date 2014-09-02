require 'test_helper'

class PermissionTest < ActiveSupport::TestCase
  setup do
    @permission = permissions(:flo_aachen_open)
  end

  test "validates presence and integrity of competition" do
    @permission.competition = nil
    assert_not_valid(@permission, :competition)

    @permission.competition_id = 1234
    assert_not_valid(@permission, :competition)
  end

  test "validates presence and integrity of user" do
    @permission.user = nil
    assert_not_valid(@permission, :user)

    @permission.user_id = 1234
    assert_not_valid(@permission, :user)
  end

  test "validates uniqueness of user, scoped to competition" do
    new_permission = @permission.dup
    assert_not_valid(new_permission, :user)

    new_permission.competition = competitions(:german_open)
    assert_valid new_permission
  end
end
