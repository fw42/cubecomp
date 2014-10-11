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

  test 'validates uniqueness of email' do
    new_user = @user.dup
    assert_not_valid(new_user, :email)
  end

  test 'password authentication' do
    @user.password = 'foobar'
    assert_valid @user

    refute @user.authenticate('wrong')
    assert @user.authenticate('foobar')
  end

  test 'checks if passwords match if both given' do
    @user.password = 'foobar'
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
end
