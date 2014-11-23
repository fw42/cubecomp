require 'test_helper'

class Admin::ThemesControllerTest < ActionController::TestCase
  setup do
    login_as(users(:admin))
    @theme = themes(:default)
  end

  test '#index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:themes)
  end

  test '#index without admin menu permission renders forbidden' do
    UserPolicy.any_instance.expects(:admin_user_menu?).at_least_once.returns(false)
    get :index
    assert_response :forbidden
  end

  test '#new' do
    get :new
    assert_response :ok
  end

  test '#new without admin menu permission renders forbidden' do
    UserPolicy.any_instance.expects(:admin_user_menu?).at_least_once.returns(false)
    get :new
    assert_response :forbidden
  end

  test '#edit' do
    get :edit, id: @theme.id
    assert_response :ok
  end

  test '#edit without admin menu permission renders forbidden' do
    UserPolicy.any_instance.expects(:admin_user_menu?).at_least_once.returns(false)
    get :new
    assert_response :forbidden
  end

  test '#create' do
    assert_difference('Theme.count', +1) do
      post :create, theme: { name: 'test theme' }
    end

    assert_redirected_to admin_themes_path
    assert_equal 'test theme', Theme.last.name
  end

  test '#create without admin menu permission renders forbidden' do
    UserPolicy.any_instance.expects(:admin_user_menu?).at_least_once.returns(false)
    post :create, theme: { name: 'forbidden theme' }
    assert_response :forbidden
  end

  test '#update' do
    patch :update, id: @theme.id, theme: { name: 'new name from update' }
    assert_equal 'new name from update', @theme.reload.name
    assert_redirected_to admin_themes_path
  end

  test '#update without admin menu permission renders forbidden' do
    UserPolicy.any_instance.expects(:admin_user_menu?).at_least_once.returns(false)
    patch :update, id: @theme.id, theme: { name: 'forbidden' }
    assert_response :forbidden
  end

  test '#destroy' do
    assert_difference('Theme.count', -1) do
      delete :destroy, id: @theme.id
    end

    assert_redirected_to admin_themes_path
  end

  test '#destroy without admin menu permission renders forbidden' do
    UserPolicy.any_instance.expects(:admin_user_menu?).at_least_once.returns(false)
    delete :destroy, id: @theme.id
    assert_response :forbidden
  end

  test '#show' do
    get :show, id: @theme.id
    assert_response :success
  end

  test '#show without admin menu permission renders forbidden' do
    UserPolicy.any_instance.expects(:admin_user_menu?).at_least_once.returns(false)
    get :show, id: @theme.id
    assert_response :forbidden
  end

  test '#show renders 404 with invalid competition id' do
    get :show, id: 17
    assert_response :not_found
  end
end
