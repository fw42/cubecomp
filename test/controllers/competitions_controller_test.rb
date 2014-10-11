require 'test_helper'

class CompetitionsControllerTest < ActionController::TestCase
  setup do
    @competition = competitions(:aachen_open)
  end

  test '#theme_file redirects to default locale if none is specified' do
    get :theme_file, competition_handle: @competition.handle
    assert_redirected_to competition_area_path(
      @competition.handle,
      @competition.default_locale.handle
    )
  end

  test '#theme_file renders 404 if competition handle is invalid' do
    get :theme_file, competition_handle: 'invalid'
    assert_response :not_found
  end

  test '#theme_file renders 404 if locale handle is invalid' do
    get :theme_file, competition_handle: @competition.handle, locale: 'invalid'
    assert_response :not_found
  end

  test '#theme_file renders 404 if theme_file is invalid' do
    get :theme_file,
      competition_handle: @competition.handle,
      locale: @competition.default_locale.handle,
      theme_file: 'invalid'

    assert_response :not_found
  end

  test '#theme_file renders index theme file if no theme_file is specified' do
    get :theme_file,
      competition_handle: @competition.handle,
      locale: @competition.default_locale.handle

    assert_response :ok
    assert_equal theme_files(:aachen_open_index).content, @response.body
  end

  test '#theme_file renders theme file and adds html extension' do
    get :theme_file,
      competition_handle: @competition.handle,
      locale: @competition.default_locale.handle,
      theme_file: 'index'

    assert_response :ok
    assert_equal theme_files(:aachen_open_index).content, @response.body
  end

  test '#theme_file prefers localized theme file filenames if they exist' do
    @competition.theme_files.create!(
      filename: 'index.de.html',
      content: 'german'
    )

    get :theme_file,
      competition_handle: @competition.handle,
      locale: 'de',
      theme_file: 'index'

    assert_response :ok
    assert_equal 'german', @response.body
  end
end
