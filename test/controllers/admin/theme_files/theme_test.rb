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
      get :index, params: { theme_id: @theme.id }
      assert_response :success
    end

    test '#index renders 404 with invalid theme_id' do
      get :index, params: { theme_id: 17 }
      assert_response :not_found
    end

    test '#index requires permission' do
      UserPolicy.any_instance.expects(:admin_user_menu?).returns(false)
      get :index, params: { theme_id: @theme.id }
      assert_response :forbidden
    end

    test '#new' do
      get :new, params: { theme_id: @theme.id }
      assert_response :success
    end

    test '#new requires permission' do
      UserPolicy.any_instance.expects(:admin_user_menu?).returns(false)
      get :new, params: { theme_id: @theme.id }
      assert_response :forbidden
    end

    test '#create' do
      theme_params = {
        filename: 'foobar.html',
        content: 'foobar!'
      }

      assert_difference('@theme.files.text_files.count') do
        post :create, params: {
          theme_id: @theme.id,
          theme_file: theme_params
        }
      end

      assert_redirected_to admin_theme_theme_files_path(@theme.id)
      assert_attributes(theme_params, @theme.files.last)
    end

    test '#create requires permission' do
      UserPolicy.any_instance.expects(:admin_user_menu?).returns(false)

      assert_no_difference 'ThemeFile.count' do
        post :create, params: {
          theme_id: @theme.id,
          theme_file: {
            filename: 'foo',
            content: 'bar'
          }
        }
      end

      assert_response :forbidden
    end

    test '#new_image' do
      get :new_image, params: { theme_id: @theme.id }
      assert_response :success
    end

    test '#new_image requires permission' do
      UserPolicy.any_instance.expects(:admin_user_menu?).returns(false)
      get :new_image, params: { theme_id: @theme.id }
      assert_response :forbidden
    end

    test '#create_image' do
      image = fixture_file_upload('files/logo.png', 'image/png')
      theme_params = {
        filename: 'logo.png',
        image: image
      }

      assert_difference('@theme.files.image_files.count') do
        post :create_image, params: {
          theme_id: @theme.id,
          theme_file: theme_params
        }
      end

      assert_redirected_to admin_theme_theme_files_path(@theme)
    end

    test '#create_image requires permission' do
      UserPolicy.any_instance.expects(:admin_user_menu?).returns(false)

      image = fixture_file_upload('files/logo.png', 'image/png')

      assert_no_difference 'ThemeFile.count' do
        post :create_image, params: {
          theme_id: @theme.id,
          theme_file: {
            filename: 'logo.png',
            image: image
          }
        }
      end

      assert_response :forbidden
    end

    test '#import_files_form' do
      get :import_files_form, params: { theme_id: @theme.id }
      assert_response :success
    end

    test '#import_files_form requires permission' do
      UserPolicy.any_instance.expects(:admin_user_menu?).returns(false)
      get :import_files_form, params: { theme_id: @theme.id }
      assert_response :forbidden
    end

    test '#import_files from theme to theme' do
      from_theme = themes(:fancy)

      post :import_files, params: {
        theme_id: @theme.id,
        from: {
          theme_id: from_theme.id,
          competition_id: "does not matter, wont be used",
          import_theme: "Import"
        }
      }

      assert_redirected_to admin_theme_theme_files_path(@theme.id)
      assert_theme_equals from_theme.files, @theme.reload.files
    end

    test '#import_files from competition to theme' do
      from_competition = competitions(:aachen_open)

      post :import_files, params: {
        theme_id: @theme.id,
        from: {
          theme_id: "does not matter, wont be used",
          competition_id: from_competition.id,
          import_competition: "Import"
        }
      }

      assert_redirected_to admin_theme_theme_files_path(@theme.id)
      assert_theme_equals from_competition.theme_files, @theme.reload.files
    end

    test '#import_files from theme to theme requires permission' do
      UserPolicy.any_instance.expects(:admin_user_menu?).returns(false)

      from_theme = themes(:fancy)

      assert_no_difference 'ThemeFile.count' do
        post :import_files, params: {
          theme_id: @theme.id,
          from: {
            theme_id: from_theme.id,
            competition_id: "does not matter, wont be used",
            import_theme: "Import"
          }
        }
      end

      assert_response :forbidden
    end

    test '#edit' do
      get :edit, params: {
        theme_id: @theme.id,
        id: @theme_file.id
      }

      assert_response :success
    end

    test "#edit requires permission" do
      UserPolicy.any_instance.expects(:admin_user_menu?).returns(false)

      get :edit, params: {
        theme_id: @theme.id,
        id: @theme_file.id
      }

      assert_response :forbidden
    end

    test '#edit has back button to theme page' do
      get :edit, params: {
        theme_id: @theme.id,
        id: @theme_file.id
      }

      url = admin_theme_theme_files_path(@theme)
      assert @response.body.include?(url)
    end

    test '#update' do
      theme_params = {
        filename: 'foobar.html',
        content: 'foobar!'
      }

      patch :update, params: {
        theme_id: @theme.id,
        id: @theme_file.id,
        theme_file: theme_params
      }

      assert_redirected_to admin_theme_theme_files_path(@theme)
      assert_attributes(theme_params, @theme_file.reload)
    end

    test "#update requires permission" do
      UserPolicy.any_instance.expects(:admin_user_menu?).returns(false)

      patch :update, params: {
        theme_id: @theme.id,
        id: @theme_file.id,
        theme_file: {
          filename: 'foobar.html',
          content: 'foobar!'
        }
      }

      assert_response :forbidden
    end

    test '#destroy' do
      assert_difference('ThemeFile.count', -1) do
        delete :destroy, params: {
          theme_id: @theme.id,
          id: @theme_file.id
        }
      end

      assert_redirected_to admin_theme_theme_files_path(@theme)
    end

    test "#destroy requires permission" do
      UserPolicy.any_instance.expects(:admin_user_menu?).returns(false)

      assert_no_difference 'ThemeFile.count' do
        delete :destroy, params: {
          theme_id: @theme.id,
          id: @theme_file.id
        }
      end

      assert_response :forbidden
    end

    test '#show_image' do
      theme_file = theme_files(:aachen_open_logo)
      theme_file.competition = nil
      theme_file.theme = @theme
      theme_file.save!

      get :show_image, params: {
        theme_id: @theme.id,
        id: theme_file.id
      }

      assert_response :ok
    end

    test "#show_image requires permission" do
      theme_file = theme_files(:aachen_open_logo)
      theme_file.competition = nil
      theme_file.theme = @theme
      theme_file.save!

      UserPolicy.any_instance.expects(:admin_user_menu?).returns(false)

      get :show_image, params: {
        theme_id: @theme.id,
        id: theme_file.id
      }

      assert_response :forbidden
    end

    test '#show_image on a theme file that is not an image returns 404' do
      get :show_image, params: {
        theme_id: @theme.id,
        id: @theme_file.id
      }

      assert_response :not_found
    end
  end
end
