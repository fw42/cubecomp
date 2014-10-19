require 'test_helper'

class Admin::CompetitionThemeFilesControllerTest < ActionController::TestCase
  tests Admin::ThemeFilesController

  setup do
    @theme_file = theme_files(:aachen_open_index)
    @competition = @theme_file.competition
    login_as(@competition.users.first)
  end

  test '#index' do
    get :index, competition_id: @competition.id
    assert_response :success
    assert_not_nil assigns(:theme_files)
  end

  test '#index renders 404 with invalid competition id' do
    get :index, competition_id: 17
    assert_response :not_found
  end

  test '#new' do
    get :new, competition_id: @competition.id
    assert_response :success
  end

  test '#create' do
    params = {
      filename: 'foobar.html',
      content: 'foobar!'
    }

    assert_difference('@competition.theme_files.count') do
      post :create, competition_id: @competition.id, theme_file: params
    end

    assert_redirected_to admin_competition_theme_files_path(@competition)
    assert_attributes(params, @competition.theme_files.last)
  end

  test '#new_image' do
    # TODO: response ok
  end

  test '#create_image' do
    # TODO: response ok
  end
end
