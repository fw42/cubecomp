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

  test '#new' do
    get :new
    assert_response :ok
  end

  test '#edit' do
    get :edit, id: @theme.id
    assert_response :ok
  end

  test '#create' do
    assert_difference('Theme.count', +1) do
      post :create, theme: { name: 'test theme' }
    end

    assert_redirected_to admin_themes_path
    assert_equal 'test theme', Theme.last.name
  end

  test '#update' do
    patch :update, id: @theme.id, theme: { name: 'new name from update' }
    assert_equal 'new name from update', @theme.reload.name
    assert_redirected_to admin_themes_path
  end

  test '#destroy' do
    assert_difference('Theme.count', -1) do
      delete :destroy, id: @theme.id
    end

    assert_redirected_to admin_themes_path
  end

  test '#show' do
    get :show, id: @theme
    assert_response :success
  end

  test '#show renders 404 with invalid competition id' do
    get :show, id: 17
    assert_response :not_found
  end
end
