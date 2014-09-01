require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:flo)
  end

  test "validates presence and format of email" do
    @user.email = ''
    assert_not_valid(@user, :email)

    @user.email = nil
    assert_not_valid(@user, :email)

    @user.email = 'foobar'
    assert_not_valid(@user, :email)

    @user.email = 'foo@bar.com'
    assert_valid @user
  end

  test "validates uniqueness of email" do
    new_user = @user.dup
    assert_not_valid(new_user, :email)
  end

  test "does not validate presence of password_digest" do
    @user.password_digest = nil
    assert_valid @user
  end

  test "password authentication" do
    @user.password = 'foobar'
    assert_valid @user

    refute @user.authenticate('wrong')
    assert @user.authenticate('foobar')
  end
end
