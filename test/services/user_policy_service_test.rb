require 'test_helper'

class UserPolicyServiceTest < ActiveSupport::TestCase
  setup do
    @regular = users(:regular_user_with_no_competitions)
    @admin = users(:admin)
    @superadmin = users(:superadmin)

    @competition = competitions(:aachen_open)
  end

  test "login? is true for admins" do
    Permission.where(user: @admin, competition: @competition).each(&:destroy!)
    @competition.delegate = nil
    assert @admin.policy.login?(@competition)
  end

  test "login? is true for delegates" do
    @competition.delegate = @regular
    assert @regular.policy.login?(@competition)
  end

  test "login? is true if user has permission" do
    user = users(:regular_user_with_one_competition)
    assert user.policy.login?(@competition)
  end

  test "login? is not true if user is not admin, delegate, and does not have permission" do
    refute @regular.policy.login?(@competition)
  end

  test "admin_user_menu? is true iff user is admin or better" do
    assert_true_iff_admin_or_better(:admin_user_menu?)
  end

  test "create_competitions? is true iff user is admin or better" do
    assert_true_iff_admin_or_better(:create_competitions?)
  end

  test "destroy_competition? is true iff user is admin or better" do
    assert_true_iff_admin_or_better(:destroy_competition?, @competition)
  end

  test "change_competition_permissions? is true iff user is admin or better" do
    assert_true_iff_admin_or_better(:change_competition_permissions?)
  end

  test "change_permission_level_to? is false if user is self" do
    [ @regular, @admin, @superadmin ].each do |user|
      User::PERMISSION_LEVELS.values.each do |level|
        refute user.policy.change_permission_level_to?(user, level)
      end
    end
  end

  test "change_permission_level_to? is true for superadmins" do
    other_superadmin = @superadmin.dup
    other_superadmin.email = 'other@superadmin.com'

    [ @regular, @admin, @superadmin ].each do |user|
      User::PERMISSION_LEVELS.values.each do |level|
        assert other_superadmin.policy.change_permission_level_to?(user, level)
      end
    end
  end

  test "change_permission_level_to? is false if not superadmin" do
    User::PERMISSION_LEVELS.values.each do |new_level|
      User::PERMISSION_LEVELS.values.each do |user_level|
        user_2 = User.new(permission_level: user_level)
        [ @regular, @admin ].each do |user_1|
          refute user_1.policy.change_permission_level_to?(user_2, new_level)
        end
      end
    end
  end

  test "change_delegate_flag? is true iff user is admin or better" do
    assert_true_iff_admin_or_better(:change_delegate_flag?, User.new)
  end

  test "create_user? is true iff permission level is higher" do
    assert_true_iff_permission_level_higher(:create_user?)
  end

  test "edit_user? is true if user is self" do
    [ @regular, @admin, @superadmin ].each do |user|
      assert user.policy.edit_user?(user)
    end
  end

  test "edit_user? is true for users other than self iff permission level is higher" do
    assert_true_iff_permission_level_higher(:edit_user?)
  end

  test "destroy_user? is false for self" do
    [ @regular, @admin, @superadmin ].each do |user|
      refute user.policy.destroy_user?(user)
    end
  end

  test "destroy_user? is true for users other than self iff permission level is higher" do
    assert_true_iff_permission_level_higher(:destroy_user?)
  end

  private

  def assert_true_iff_admin_or_better(method_name, *args)
    refute @regular.policy.public_send(method_name, *args)
    @regular.permission_level = User::PERMISSION_LEVELS[:admin]
    assert @regular.policy.public_send(method_name, *args)
    @regular.permission_level = User::PERMISSION_LEVELS[:superadmin]
    assert @regular.policy.public_send(method_name, *args)
  end

  def assert_true_iff_permission_level_higher(method_name, *args)
    User::PERMISSION_LEVELS.values.each do |level_1|
      user_1 = User.new(permission_level: level_1)
      User::PERMISSION_LEVELS.values.each do |level_2|
        user_2 = User.new(permission_level: level_2)

        allowed = user_1.policy.public_send(method_name, user_2, *args)
        if level_1 > level_2
          assert allowed
        else
          refute allowed
        end
      end
    end
  end
end
