require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:flo)
  end

  test 'validates presence and format of email' do
    @user.email = ''
    assert_not_valid(@user, :email)

    @user.email = nil
    assert_not_valid(@user, :email)

    @user.email = 'foobar'
    assert_not_valid(@user, :email)

    @user.email = 'foo@bar.com'
    assert_valid @user
  end

  test "inactive users are allowed to not have an email address" do
    @user.email = ''
    @user.active = false
    assert_valid @user
  end

  test 'validates uniqueness of email' do
    new_user = @user.dup
    assert_not_valid(new_user, :email)
  end

  test 'password authentication' do
    @user.password = 'foobartest'
    assert_valid @user

    refute @user.authenticate('wrong')
    assert @user.authenticate('foobartest')
  end

  test 'password presence' do
    new_user = @user.dup
    @user.destroy!
    new_user.password = nil
    assert_not_valid(new_user, :password)
    new_user.password = 'x' * 10
    assert_valid(new_user)
  end

  test 'validates password minimum length' do
    @user.password = 'x'
    assert_not_valid(@user, :password)

    @user.password = 'x' * 8
    assert_valid(@user)
  end

  test 'checks if passwords match if both given' do
    @user.password = 'foobartest'
    @user.password_confirmation = 'bblabla'
    assert_not_valid(@user, :password_confirmation)
  end

  test 'destroying user destroys permissions' do
    count = @user.permissions.count
    assert_difference 'Permission.count', -1 * count do
      @user.destroy
    end
  end

  test 'destroying a delegate nullifies the column on competition' do
    competition = competitions(:aachen_open)
    competition.delegate = users(:delegate)
    competition.save!

    assert_no_difference 'Competition.count' do
      competition.delegate.destroy!
      assert_nil competition.reload.delegate_user_id
    end
  end

  test 'destroying an owner nullifies the column on competition' do
    competition = competitions(:aachen_open)
    competition.owner = users(:flo)
    competition.save!

    assert_no_difference 'Competition.count' do
      competition.owner.destroy!
      assert_nil competition.reload.owner_user_id
    end
  end

  test 'removing delegate attribute from user nullifies the column on competition' do
    competition = competitions(:aachen_open)
    competition.delegate = user = users(:delegate)
    competition.save!

    user.delegate = false
    user.save!

    assert_equal nil, competition.reload.delegate_user_id
  end

  test 'user version is incremented when password or email is changed' do
    assert_equal 0, @user.version

    @user.password = 'blablabla'
    @user.password_confirmation = 'blablabla'
    @user.save!
    assert_equal 1, @user.version

    @user.email = 'foo@bar.com'
    @user.save!
    assert_equal 2, @user.version

    @user.first_name = 'Bla'
    @user.save!
    assert_equal 2, @user.version
  end

  test "user requires old password when changing current password" do
    @user.password = @user.password_confirmation = 'old_old_old'
    @user.save!

    @user.validate_old_password = true

    @user.password = @user.password_confirmation = 'new_new_new'
    assert_not_valid(@user, :old_password)

    @user.old_password = 'wrong_wrong_wrong'
    assert_not_valid(@user, :old_password)

    @user.old_password = 'old_old_old'
    assert_valid(@user)
  end

  test "user requires old password when changing email" do
    @user.password = @user.password_confirmation = 'old_old_old'
    @user.save!

    @user.validate_old_password = true

    @user.email = 'new@foobar.com'
    assert_not_valid(@user, :old_password)

    @user.old_password = 'wrong_wrong_wrong'
    assert_not_valid(@user, :old_password)

    @user.old_password = 'old_old_old'
    assert_valid(@user)
  end
end
