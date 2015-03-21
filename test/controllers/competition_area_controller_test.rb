require 'test_helper'

class CompetitionAreaControllerTest < ActionController::TestCase
  setup do
    @competition = competitions(:aachen_open)
  end

  test '#render_theme_file redirects to default locale if none is specified' do
    get :render_theme_file, competition_handle: @competition.handle
    assert_redirected_to competition_area_path(
      @competition.handle,
      @competition.default_locale.handle
    )
  end

  test '#render_theme_file redirects to locale from cookie if none is specified in params' do
    cookies[:locale] = 'en'
    get :render_theme_file, competition_handle: @competition.handle
    assert_redirected_to competition_area_path(
      @competition.handle,
      'en'
    )
  end

  test '#render_theme_file with locale in params sets locale in cookie and in I18n' do
    get :render_theme_file, competition_handle: @competition.handle, locale: "en"
    assert_response :ok
    assert_equal 'en', response.cookies['locale']
  end

  test '#render_theme_file with invalid locale in cookie redirects to default locale' do
    cookies[:locale] = 'foobar'
    get :render_theme_file, competition_handle: @competition.handle
    assert_redirected_to competition_area_path(
      @competition.handle,
      @competition.default_locale.handle
    )
  end

  test '#render_theme_file renders 404 if competition handle is invalid' do
    get :render_theme_file, competition_handle: 'invalid'
    assert_response :not_found
  end

  test '#render_theme_file renders 404 if locale handle is invalid' do
    get :render_theme_file, competition_handle: @competition.handle, locale: 'invalid'
    assert_response :not_found
  end

  test '#render_theme_file renders 404 if theme_file is invalid' do
    get :render_theme_file,
      competition_handle: @competition.handle,
      locale: @competition.default_locale.handle,
      theme_file: 'invalid'

    assert_response :not_found
  end

  test '#render_theme_file renders index theme file if no theme_file is specified' do
    get :render_theme_file,
      competition_handle: @competition.handle,
      locale: @competition.default_locale.handle

    assert_response :ok
    assert_equal "Aachen Open -- " + theme_files(:aachen_open_index).content, @response.body
  end

  test '#render_theme_file renders theme file and adds html extension' do
    get :render_theme_file,
      competition_handle: @competition.handle,
      locale: @competition.default_locale.handle,
      theme_file: 'index'

    assert_response :ok
    assert_equal "Aachen Open -- " + theme_files(:aachen_open_index).content, @response.body
  end

  test '#render_theme_file prefers localized theme file filenames if they exist' do
    @competition.theme_files.create!(
      filename: 'index.de.html',
      content: 'german'
    )

    get :render_theme_file,
      competition_handle: @competition.handle,
      locale: 'de',
      theme_file: 'index'

    assert_response :ok
    assert_equal 'Aachen Open -- german', @response.body
  end

  test '#render_theme_file with registration_form renders hidden theme_file input field and csrf token' do
    theme_file = theme_files(:aachen_open_index)
    theme_file.update_attributes(content: '{{ registration_form }}')

    with_csrf_protection do
      get :render_theme_file, competition_handle: @competition.handle, locale: 'de'

      assert_match /#{Regexp.escape('<input type="hidden" name="theme_file" id="theme_file" value="index.html" />')}/,
        response.body

      assert_match /#{Regexp.escape('<input type="hidden" name="authenticity_token" value=')}/, response.body
    end
  end

  test '#render_theme_file renders html files in layout' do
    layout = theme_files(:aachen_open_layout)
    layout.update_attributes(content: "FOOBAR {{ content_for_layout }} TEST")
    theme_file = theme_files(:aachen_open_index)
    theme_file.update_attributes(content: 'BLABLA')

    get :render_theme_file,
      competition_handle: @competition.handle,
      locale: 'de',
      theme_file: 'index'

    assert_equal 'FOOBAR BLABLA TEST', response.body
  end

  test '#render_theme_file renders css files without layout' do
    layout = theme_files(:aachen_open_layout)
    layout.update_attributes(content: "FOOBAR {{ content_for_layout }} TEST")

    get :render_theme_file,
      competition_handle: @competition.handle,
      locale: 'de',
      theme_file: 'style',
      format: 'css'

    assert_no_match /FOOBAR/, response.body
    assert_match /body {/, response.body
  end
end
