require 'test_helper'

module Admin::ThemeFiles
  class ThemeTest < ActionController::TestCase
    tests Admin::ThemeFilesController

    setup do
      @theme_file = theme_files(:default_index)
      @theme = @theme_file.theme
      login_as(users(:admin))
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

    test '#index requires permission' do
      UserPolicy.any_instance.expects(:admin_user_menu?).returns(false)
      get :index, theme_id: @theme.id
      assert_response :forbidden
    end

    test '#new' do
      get :new, theme_id: @theme.id
      assert_response :success
    end

    test '#new requires permission' do
      UserPolicy.any_instance.expects(:admin_user_menu?).returns(false)
      get :new, theme_id: @theme.id
      assert_response :forbidden
    end

    test '#create' do
      params = {
        filename: 'foobar.html',
        content: 'foobar!'
      }

      assert_difference('@theme.files.text_files.count') do
        post :create, theme_id: @theme.id, theme_file: params
      end

      assert_redirected_to admin_theme_theme_files_path(@theme.id)
      assert_attributes(params, @theme.files.last)
    end

    test '#create requires permission' do
      UserPolicy.any_instance.expects(:admin_user_menu?).returns(false)

      assert_no_difference 'ThemeFile.count' do
        post :create, theme_id: @theme.id, theme_file: { filename: 'foo', content: 'bar' }
      end

      assert_response :forbidden
    end

    test '#new_image' do
      get :new_image, theme_id: @theme.id
      assert_response :success
    end

    test '#new_image requires permission' do
      UserPolicy.any_instance.expects(:admin_user_menu?).returns(false)
      get :new_image, theme_id: @theme.id
      assert_response :forbidden
    end

    test '#create_image' do
      image = fixture_file_upload('files/logo.png', 'image/jpeg')
      params = {
        filename: 'logo.png',
        image: image
      }

      assert_difference('@theme.files.image_files.count') do
        post :create_image, theme_id: @theme.id, theme_file: params
      end

      assert_redirected_to admin_theme_theme_files_path(@theme)
    end

    test '#create_image requires permission' do
      UserPolicy.any_instance.expects(:admin_user_menu?).returns(false)

      image = fixture_file_upload('files/logo.png', 'image/jpeg')

      assert_no_difference 'ThemeFile.count' do
        post :create_image, theme_id: @theme.id, theme_file: { filename: 'logo.png', image: image }
      end

      assert_response :forbidden
    end

    test '#new_from_existing' do
      get :new_from_existing, theme_id: @theme.id
      assert_response :success
    end

    test '#new_from_existing requires permission' do
      UserPolicy.any_instance.expects(:admin_user_menu?).returns(false)
      get :new_from_existing, theme_id: @theme.id
      assert_response :forbidden
    end

    test '#create_from_existing from theme to theme' do
      from_theme = themes(:fancy)

      post :create_from_existing, theme_id: @theme.id, from: {
        theme_id: from_theme.id,
        competition_id: "does not matter, wont be used",
        load_theme: "Load"
      }

      assert_redirected_to admin_theme_theme_files_path(@theme.id)
      assert_theme_equals from_theme.files, @theme.reload.files
    end

    test '#create_from_existing from competition to theme' do
      from_competition = competitions(:aachen_open)

      post :create_from_existing, theme_id: @theme.id, from: {
        theme_id: "does not matter, wont be used",
        competition_id: from_competition.id,
        load_competition: "Load"
      }

      assert_redirected_to admin_theme_theme_files_path(@theme.id)
      assert_theme_equals from_competition.theme_files, @theme.reload.files
    end

    test '#create_from_existing from theme to theme requires permission' do
      UserPolicy.any_instance.expects(:admin_user_menu?).returns(false)

      from_theme = themes(:fancy)

      assert_no_difference 'ThemeFile.count' do
        post :create_from_existing, theme_id: @theme.id, from: {
          theme_id: from_theme.id,
          competition_id: "does not matter, wont be used",
          load_theme: "Load"
        }
      end

      assert_response :forbidden
    end
  end
end
