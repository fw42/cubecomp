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
      get :index, params: { competition_id: @competition.id }
      assert_response :success
    end

    test '#index renders 404 with invalid competition_id' do
      get :index, params: { competition_id: 17 }
      assert_response :not_found
    end

    test '#index requires permission' do
      mock_login_policy(false)
      get :index, params: { competition_id: @competition.id }
      assert_response :forbidden
    end

    test '#new' do
      get :new, params: { competition_id: @competition.id }
      assert_response :success
    end

    test '#new requires permission' do
      mock_login_policy(false)

      get :new, params: { competition_id: @competition.id }

      assert_response :forbidden
    end

    test '#create' do
      theme_params = {
        filename: 'foobar.html',
        content: 'foobar!'
      }

      assert_difference('@competition.theme_files.text_files.count') do
        post :create, params: {
          competition_id: @competition.id,
          theme_file: theme_params
        }
      end

      assert_redirected_to admin_competition_theme_files_path(@competition)
      assert_attributes(theme_params, @competition.theme_files.last)
    end

    test '#create requires permission' do
      mock_login_policy(false)

      assert_no_difference 'ThemeFile.count' do
        post :create, params: {
          competition_id: @competition.id,
          theme_file: {
            filename: 'foo',
            content: 'bar'
          }
        }
      end

      assert_response :forbidden
    end

    test '#new_image' do
      get :new_image, params: { competition_id: @competition.id }
      assert_response :success
    end

    test '#new_image requires permission' do
      mock_login_policy(false)

      get :new_image, params: { competition_id: @competition.id }

      assert_response :forbidden
    end

    test '#create_image' do
      @competition.theme_files.each(&:destroy!)

      image = fixture_file_upload('files/logo.png', 'image/png')

      theme_params = {
        filename: 'logo.png',
        image: image
      }

      assert_difference('@competition.theme_files.image_files.count') do
        post :create_image, params: {
          competition_id: @competition.id,
          theme_file: theme_params
        }
      end

      assert_redirected_to admin_competition_theme_files_path(@competition)
    end

    test '#create_image requires permission' do
      mock_login_policy(false)

      image = fixture_file_upload('files/logo.png', 'image/png')

      assert_no_difference 'ThemeFile.count' do
        post :create_image, params: {
          competition_id: @competition.id,
          theme_file: {
            filename: 'logo.png',
            image: image
          }
        }
      end

      assert_response :forbidden
    end

    test '#import_files_form' do
      get :import_files_form, params: { competition_id: @competition.id }
      assert_response :success
    end

    test '#import_files_form requires permission' do
      mock_login_policy(false)

      get :import_files_form, params: { competition_id: @competition.id }
      assert_response :forbidden
    end

    test '#import_files from theme to competition' do
      from_theme = themes(:fancy)

      post :import_files, params: {
        competition_id: @competition.id,
        from: {
          theme_id: from_theme.id,
          competition_id: "does not matter, wont be used",
          import_theme: "Import"
        }
      }

      assert_redirected_to admin_competition_theme_files_path(@competition)
      assert_theme_equals from_theme.files, @competition.reload.theme_files
    end

    test '#import_files from competition to competition' do
      to_competition = competitions(:german_open)
      login_as(to_competition.users.first)
      from_competition = competitions(:aachen_open)

      post :import_files, params: {
        competition_id: to_competition.id,
        from: {
          theme_id: "does not matter, wont be used",
          competition_id: from_competition.id,
          import_competition: "Import"
        }
      }

      assert_redirected_to admin_competition_theme_files_path(to_competition)
      assert_theme_equals from_competition.theme_files, to_competition.reload.theme_files
    end

    test '#import_files requires permission' do
      mock_login_policy(false)

      from_theme = themes(:fancy)

      assert_no_difference 'ThemeFile.count' do
        post :import_files, params: {
          competition_id: @competition.id,
          from: {
            theme_id: from_theme.id,
            competition_id: "does not matter, wont be used",
            import_theme: "Import"
          }
        }
      end

      assert_response :forbidden
    end

    test '#import_files does not allow to load from competition that user has no access to' do
      to_competition = competitions(:german_open)
      from_competition = competitions(:aachen_open)

      mock_login_policy(true, to_competition)
      mock_login_policy(false, from_competition)

      assert_no_difference 'ThemeFile.count' do
        post :import_files, params: {
          competition_id: to_competition.id,
          from: {
            theme_id: "does not matter, wont be used",
            competition_id: from_competition.id,
            import_competition: "Import"
          }
        }
      end

      assert_response :forbidden
    end

    test '#edit' do
      get :edit, params: {
        competition_id: @competition.id,
        id: @theme_file.id
      }

      assert_response :success
    end

    test "#edit requires permission" do
      mock_login_policy(false)

      get :edit, params: {
        competition_id: @competition.id,
        id: @theme_file.id
      }

      assert_response :forbidden
    end

    test '#edit has back button to competition' do
      get :edit, params: {
        competition_id: @competition.id,
        id: @theme_file.id
      }

      url = admin_competition_theme_files_path(@competition, @theme_file)
      assert @response.body.include?(url)
    end

    test '#update' do
      theme_params = {
        filename: 'foobar.html',
        content: 'foobar!'
      }

      patch :update, params: {
        competition_id: @competition.id,
        id: @theme_file.id,
        theme_file: theme_params
      }

      assert_redirected_to admin_competition_theme_files_path(@competition)
      assert_attributes(theme_params, @theme_file.reload)
    end

    test "#update requires permission" do
      mock_login_policy(false)

      theme_params = {
        filename: 'foobar.html',
        content: 'foobar!'
      }

      patch :update, params: {
        competition_id: @competition.id,
        id: @theme_file.id,
        theme_file: theme_params
      }

      assert_response :forbidden
    end

    test '#destroy' do
      assert_difference('ThemeFile.count', -1) do
        delete :destroy, params: {
          competition_id: @competition.id,
          id: @theme_file.id
        }
      end

      assert_redirected_to admin_competition_theme_files_path(@competition)
    end

    test "#destroy requires permission" do
      mock_login_policy(false)

      assert_no_difference 'ThemeFile.count' do
        delete :destroy, params: {
          competition_id: @competition.id,
          id: @theme_file.id
        }
      end

      assert_response :forbidden
    end

    test '#show_image' do
      theme_file = theme_files(:aachen_open_logo)

      get :show_image, params: {
        competition_id: theme_file.competition.id,
        id: theme_file.id
      }

      assert_response :ok
    end

    test "#show_image requires permission" do
      theme_file = theme_files(:aachen_open_logo)
      @competition = theme_file.competition
      mock_login_policy(false)

      get :show_image, params: {
        competition_id: @competition.id,
        id: theme_file.id
      }

      assert_response :forbidden
    end

    test '#show_image on a theme file that is not an image returns 404' do
      get :show_image, params: {
        competition_id: @competition.id,
        id: @theme_file.id
      }

      assert_response :not_found
    end

    private

    def mock_login_policy(value, compare_to_competition = @competition)
      UserPolicy
        .any_instance
        .expects(:login?)
        .with{ |competition| competition.id == compare_to_competition.id }
        .returns(value)
    end
  end
end
