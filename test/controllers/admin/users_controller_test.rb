require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  setup do
    login_as(users(:admin))
    @user = users(:flo)
  end

  test '#index' do
    get :index
    assert_response :success
  end

  test '#index without admin menu permission renders forbidden' do
    UserPolicy.any_instance.expects(:admin_user_menu?).at_least_once.returns(false)
    get :index
    assert_response :forbidden
  end

  test '#new' do
    get :new
    assert_response :success
  end

  test '#new without admin menu permission renders forbidden' do
    UserPolicy.any_instance.expects(:admin_user_menu?).at_least_once.returns(false)
    get :new
    assert_response :forbidden
  end

  test '#create' do
    params = {
      email: 'bob@cubecomp.de',
      first_name: 'Bob',
      last_name: 'Bobsen',
      password: 'foobartest',
      password_confirmation: 'foobartest',
      permission_level: User::PERMISSION_LEVELS.values.min,
      address: 'Foo Bar 1, 123 Foo, Germany'
    }

    assert_difference('User.count') do
      post :create, user: params
    end

    assert_redirected_to admin_users_path
    user = User.find_by(email: 'bob@cubecomp.de')
    assert_attributes(params.except(:password, :password_confirmation), user)
    assert user.authenticate(params[:password])
  end

  test '#create without admin menu permission renders forbidden' do
    UserPolicy.any_instance.expects(:admin_user_menu?).at_least_once.returns(false)
    post :create, user: { first_name: 'Bob' }
    assert_response :forbidden
  end

  test '#create without create_user? permission renders forbidden' do
    UserPolicy.any_instance.expects(:create_user?).at_least_once.returns(false)
    post :create, user: { first_name: 'Bob' }
    assert_response :forbidden
  end

  test '#create permission level renders forbidden if UserPolicy#change_permission_level_to? is false' do
    UserPolicy.any_instance.expects(:change_permission_level_to?)
      .with{ |_, level| level.to_i == 1 }
      .at_least_once
      .returns(false)

    assert_no_difference('User.count') do
      post :create, user: { permission_level: 1 }
    end

    assert_response :forbidden
  end

  test '#create delegate flag without permission' do
    UserPolicy.any_instance.expects(:change_delegate_flag?)
      .at_least_once
      .returns(false)

    assert_no_difference('User.count') do
      post :create, user: { delegate: true }
    end

    assert_response :forbidden
  end

  test '#edit' do
    get :edit, id: @user.id
    assert_response :success
  end

  test '#edit with UserPolicy#edit_user? false renders forbidden' do
    UserPolicy.any_instance.expects(:edit_user?).with{ |user| user.id == @user.id }.at_least_once.returns(false)
    get :edit, id: @user.id
    assert_response :forbidden
  end

  test '#edit renders 404 with invalid competition id' do
    get :edit, id: 17
    assert_response :not_found
  end

  test '#update' do
    params = {
      email: 'bob@cubecomp.de',
      first_name: 'Bob',
      last_name: 'Bobsen',
      password: 'foobartest',
      password_confirmation: 'foobartest',
      address: 'Foo Bar 1, 123 Foo, Germany',
      delegate: true
    }

    patch :update, id: @user.id, user: params

    assert assigns(:user)
    assert_redirected_to admin_users_path
    user = User.find_by(email: 'bob@cubecomp.de')
    assert_attributes(params.except(:password, :password_confirmation), user)
    assert user.authenticate(params[:password])
  end

  test '#update own password without old password fails' do
    UserPolicy.any_instance.expects(:change_user_password_without_old_password?).at_least_once.returns(false)

    @user.password = @user.password_confirmation = 'old_old_old'
    @user.save!

    patch :update, id: @user.id, user: { password: "new_new_new", password_confirmation: "new_new_new" }
    refute @user.reload.authenticate('new_new_new')

    patch :update, id: @user.id, user: {
      old_password: "wrong_wrong_wrong",
      password: "new_new_new",
      password_confirmation: "new_new_new"
    }
    refute @user.reload.authenticate('new_new_new')

    patch :update, id: @user.id, user: {
      old_password: "old_old_old",
      password: "new_new_new",
      password_confirmation: "new_new_new"
    }
    assert @user.reload.authenticate('new_new_new')
  end

  test '#update permission level renders forbidden if UserPolicy#change_permission_level_to? is false' do
    UserPolicy.any_instance.expects(:change_permission_level_to?)
      .with{ |user, level| user.id == @user.id && level.to_i == 1 }
      .at_least_once
      .returns(false)

    patch :update, id: @user.id, user: { permission_level: 1 }
    assert_response :forbidden
  end

  test '#update with UserPolicy#edit_user? false renders forbidden' do
    UserPolicy.any_instance.expects(:edit_user?).with{ |user| user.id == @user.id }.at_least_once.returns(false)
    patch :update, id: @user.id, user: {}
    assert_response :forbidden
  end

  test '#update delegate flag without permission' do
    UserPolicy.any_instance.expects(:change_delegate_flag?)
      .with{ |user| user.id == @user.id }
      .at_least_once
      .returns(false)

    patch :update, id: @user.id, user: { delegate: true }
    assert_response :forbidden
    assert_equal false, @user.reload.delegate
  end

  test '#update active with permission' do
    UserPolicy.any_instance.expects(:disable_user?).returns(true)
    patch :update, id: @user.id, user: { active: false }
    assert_equal false, @user.reload.active
  end

  test '#update active without permission' do
    UserPolicy.any_instance.expects(:disable_user?).returns(false)
    patch :update, id: @user.id, user: { active: false }
    assert_response :forbidden
    assert_equal true, @user.reload.active
  end

  test "#update when passwords don't match fails" do
    patch :update, id: @user.id, user: { password: 'foofoofoo', password_confirmation: 'barbarbar' }
    assert_response 200
    assert_equal ["doesn't match Password"], assigns(:user).errors[:password_confirmation]
    refute @user.reload.authenticate(:foo)
  end

  test '#update with blank password fields doesnt change password' do
    patch :update, id: @user.id, user: { password: '', password_confirmation: '' }
    @user.reload
    assert @user.authenticate('test')
  end

  test '#update to change competition permissions for user' do
    competition1 = competitions(:aachen_open)
    competition2 = competitions(:german_open)
    @user.permissions.each(&:destroy!)
    @user.permissions.create!(competition_id: competition1.id)

    patch :update, id: @user.id, user: {
      permissions_attributes: {
        "0" => {
          "competition_id" => competition1.id,
          "_destroy" => "0"
        },
        "1" => {
          "competition_id" => competition2.id,
          "_destroy" => "1"
        }
      }
    }

    @user.reload
    assert_equal 1, @user.permissions.where(competition_id: competition1.id).size
    assert_equal 0, @user.permissions.where(competition_id: competition2.id).size
  end

  test '#create and #update permissions without #change_competition_permissions? renders forbidden' do
    competition = competitions(:aachen_open)

    UserPolicy.any_instance.expects(:change_competition_permissions?)
      .with{ |c| c.id == competition.id }
      .at_least_once
      .returns(false)

    post :create, id: @user.id, user: {
      permissions_attributes: {
        "0" => {
          "competition_id" => competition.id,
          "_destroy" => "0"
        }
      }
    }
    assert_response :forbidden

    patch :update, id: @user.id, user: {
      permissions_attributes: {
        "0" => {
          "competition_id" => competition.id,
          "_destroy" => "0"
        }
      }
    }
    assert_response :forbidden
  end

  test '#destroy' do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user.id
    end

    assert_redirected_to admin_users_path
  end

  test '#destroy without admin menu permission renders forbidden' do
    UserPolicy.any_instance.expects(:admin_user_menu?).at_least_once.returns(false)
    delete :destroy, id: @user.id
    assert_response :forbidden
  end

  test '#destroy with UserPolicy#destroy_user? false renders forbidden' do
    UserPolicy.any_instance.expects(:destroy_user?).with{ |user| user.id == @user.id }.returns(false)
    assert_no_difference('User.count') do
      delete :destroy, id: @user.id
    end
    assert_response :forbidden
  end
end
