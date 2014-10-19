require 'test_helper'

class Admin::ThemeThemeFilesControllerTest < ActionController::TestCase
  tests Admin::ThemeFilesController

  setup do
    # ...
  end

  test '#index' do
    get :index, theme_id: @theme.id
    assert_response :success
    assert_not_nil assigns(:theme_files)
  end

  test '#index renders 404 with invalid theme_id' do
    get :index, theme_id: 17
    assert_response :not_found
  end

  test '#new' do
    get :new, theme_id: @theme.id
    assert_response :success
  end

  test '#create' do
    params = {
      filename: 'foobar.html',
      content: 'foobar!'
    }

    assert_difference('@theme.files.count') do
      post :create, theme_id: @theme.id, theme_file: params
    end

    assert_redirected_to edit_admin_theme_file_path(assigns(:theme_file))
    assert_attributes(params, @theme.files.last)
  end

  test '#new_image' do
    # TODO: response ok
  end

  test '#create_image' do
    # TODO: response ok
  end
end