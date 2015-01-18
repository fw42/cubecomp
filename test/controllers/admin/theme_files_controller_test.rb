require 'test_helper'

class Admin::ThemeFilesControllerTest < ActionController::TestCase
  setup do
    @theme_file = theme_files(:aachen_open_index)
    @competition = @theme_file.competition
    login_as(@competition.users.first)
  end

  test '#edit' do
    get :edit, id: @theme_file.id
    assert_response :success
  end

  test "#edit a competition's theme file doesn't work if user doesn't have permission for that competition" do
    flunk
  end

  test "#edit a theme's theme file doesn't work if user doesn't have permission to edit themes" do
    flunk
  end

  test '#edit theme file that has theme has back button to theme page' do
    get :edit, id: @theme_file.id
    url = admin_competition_theme_files_path(@competition)
    assert @response.body.include?(url)
  end

  test '#edit theme file that has competition has back button to competition' do
    theme_file = theme_files(:template_index)
    get :edit, id: theme_file.id
    url = admin_theme_theme_files_path(theme_file.theme)
    assert @response.body.include?(url)
  end

  test '#update' do
    params = {
      filename: 'foobar.html',
      content: 'foobar!'
    }

    patch :update, id: @theme_file.id, theme_file: params

    assert_redirected_to edit_admin_theme_file_path(assigns(:theme_file))
    assert_attributes(params, @theme_file.reload)
  end

  test "#update a competition's theme file doesn't work if user doesn't have permission for that competition" do
    flunk
  end

  test "#update a theme's theme file doesn't work if user doesn't have permission to edit themes" do
    flunk
  end

  test '#destroy' do
    assert_difference('ThemeFile.count', -1) do
      delete :destroy, id: @theme_file.id
    end

    assert_redirected_to admin_competition_theme_files_path(@competition)
  end

  test "#destroy a competition's theme file doesn't work if user doesn't have permission for that competition" do
    flunk
  end

  test "#destroy a theme's theme file doesn't work if user doesn't have permission to edit themes" do
    flunk
  end

  test '#show_image' do
    theme_file = theme_files(:aachen_open_logo)
    get :show_image, id: theme_file.id
    assert_response :ok
  end

  test "#show_image a competition's image doesn't work if user doesn't have permission for that competition" do
    flunk
  end

  test "#show_iage a theme's theme file doesn't work if user doesn't have permission to edit themes" do
    flunk
  end

  test '#show_image on a theme file that is not an image returns 404' do
    get :show_image, id: @theme_file.id
    assert_response :not_found
  end

  test '#new_from_existing' do
    flunk
  end

  tesit '#create_from_existing from theme to theme' do
    flunk
  end

  test '#create_from_existing from theme to competition' do
    flunk
  end

  test '#create_from_existing from competition to theme' do
    flunk
  end

  test '#create_from_existing from competition to competition' do
    flunk
  end

  test '#create_from_existing does not allow to load from competition that user has no access to' do
    flunk
  end
end
