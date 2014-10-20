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

  test '#edit theme file that has theme has back button to theme page' do
    # TODO
  end

  test '#edit theme file that has competition has back button to competition' do
    # TODO
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

  test '#destroy' do
    assert_difference('ThemeFile.count', -1) do
      delete :destroy, id: @theme_file.id
    end

    assert_redirected_to admin_competition_theme_files_path(@competition)
  end

  test "#update can't unassign competition_id" do
    # TODO
  end

  test "#update can't assign different competition_id" do
    # TODO
  end

  test "#update can't assign theme_id" do
    # TODO
  end

  test '#show_image' do
    # TODO: response ok
    # TODO: 404 if id belongs to non-image
  end
end
