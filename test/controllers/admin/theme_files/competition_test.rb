require 'test_helper'

module Admin::ThemeFiles
  class CompetitionTest < ActionController::TestCase
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

      assert_difference('@competition.theme_files.text_files.count') do
        post :create, competition_id: @competition.id, theme_file: params
      end

      assert_redirected_to admin_competition_theme_files_path(@competition)
      assert_attributes(params, @competition.theme_files.last)
    end

    test '#new_image' do
      get :new_image, competition_id: @competition.id
      assert_response :success
    end

    test '#create_image' do
      image = fixture_file_upload('files/logo.png', 'image/jpeg')
      params = {
        filename: 'logo.png',
        image: image
      }

      assert_difference('@competition.theme_files.image_files.count') do
        post :create_image, competition_id: @competition.id, theme_file: params
      end

      assert_redirected_to admin_competition_theme_files_path(@competition)
    end

    test '#new_from_existing' do
      get :new_from_existing, competition_id: @competition.id
      assert_response :success
    end

    test '#create_from_existing from theme to competition' do
      flunk
    end

    test '#create_from_existing from competition to competition' do
      flunk
    end

    test '#create_from_existing does not allow to load from competition that user has no access to' do
      flunk
    end
  end
end
