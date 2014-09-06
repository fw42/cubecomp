require 'test_helper'

class Admin::ThemeFilesControllerTest < ActionController::TestCase
  setup do
    @theme_file = theme_files(:aachen_open_index)
    @competition = @theme_file.competition
  end

  test "#index" do
    get :index, competition_id: @competition.id
    assert_response :success
    assert_not_nil assigns(:theme_files)
  end

  test "#new" do
    get :new, competition_id: @competition.id
    assert_response :success
  end

  test "#create" do
    params = {
      filename: 'foobar.html',
      content: 'foobar!'
    }

    assert_difference('@competition.theme_files.count') do
      post :create, competition_id: @competition.id, theme_file: params
    end

    assert_redirected_to edit_admin_theme_file_path(assigns(:theme_file))
    assert_attributes(params, @competition.theme_files.last)
  end

  test "#edit" do
    get :edit, id: @theme_file
    assert_response :success
  end

  test "#update" do
    params = {
      filename: 'foobar.html',
      content: 'foobar!'
    }

    patch :update, id: @theme_file, theme_file: params

    assert_redirected_to edit_admin_theme_file_path(assigns(:theme_file))
    assert_attributes(params, @theme_file.reload)
  end

  test "#destroy" do
    assert_difference('@competition.theme_files.count', -1) do
      delete :destroy, id: @theme_file
    end

    assert_redirected_to admin_competition_theme_files_path(@competition)
  end
end
