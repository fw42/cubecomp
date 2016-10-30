require 'test_helper'

class CompetitionAreaControllerTest < ActionController::TestCase
  setup do
    @competition = competitions(:aachen_open)
  end

  test '#render_theme_file redirects to default locale if none is specified' do
    get :render_theme_file, params: { competition_handle: @competition.handle }
    assert_redirected_to competition_area_path(
      @competition.handle,
      @competition.default_locale.handle
    )
  end

  test '#render_theme_file redirects to locale from cookie if none is specified in params' do
    cookies[:locale] = 'en'
    get :render_theme_file, params: { competition_handle: @competition.handle }
    assert_redirected_to competition_area_path(
      @competition.handle,
      'en'
    )
  end

  test '#render_theme_file with locale in params sets locale in cookie and in I18n' do
    get :render_theme_file, params: { competition_handle: @competition.handle, locale: "en" }
    assert_response :ok
    assert_equal 'en', response.cookies['locale']
  end

  test '#render_theme_file with invalid locale in cookie redirects to default locale' do
    cookies[:locale] = 'foobar'
    get :render_theme_file, params: { competition_handle: @competition.handle }
    assert_redirected_to competition_area_path(
      @competition.handle,
      @competition.default_locale.handle
    )
  end

  test '#render_theme_file renders 404 if competition handle is invalid' do
    get :render_theme_file, params: { competition_handle: 'invalid' }
    assert_response :not_found
  end

  test '#render_theme_file renders 404 if locale handle is invalid' do
    get :render_theme_file, params: { competition_handle: @competition.handle, locale: 'invalid' }
    assert_response :not_found
  end

  test '#render_theme_file renders 404 if theme_file is invalid' do
    get :render_theme_file, params: {
      competition_handle: @competition.handle,
      locale: @competition.default_locale.handle,
      theme_file: 'invalid'
    }

    assert_response :not_found
  end

  test '#render_theme_file renders index theme file if no theme_file is specified' do
    get :render_theme_file, params: {
      competition_handle: @competition.handle,
      locale: @competition.default_locale.handle
    }

    assert_response :ok
    assert_equal "Aachen Open -- " + theme_files(:aachen_open_index).content, @response.body
  end

  test '#render_theme_file renders theme file and adds html extension' do
    get :render_theme_file, params: {
      competition_handle: @competition.handle,
      locale: @competition.default_locale.handle,
      theme_file: 'index'
    }

    assert_response :ok
    assert_equal "Aachen Open -- " + theme_files(:aachen_open_index).content, @response.body
  end

  test '#render_theme_file prefers localized theme file filenames if they exist' do
    @competition.theme_files.create!(
      filename: 'index.de.html',
      content: 'german'
    )

    get :render_theme_file, params: {
      competition_handle: @competition.handle,
      locale: 'de',
      theme_file: 'index'
    }

    assert_response :ok
    assert_equal 'Aachen Open -- german', @response.body
  end

  test '#render_theme_file renders html files in layout' do
    layout = theme_files(:aachen_open_layout)
    layout.update_attributes(content: "FOOBAR {{ content_for_layout }} TEST")
    theme_file = theme_files(:aachen_open_index)
    theme_file.update_attributes(content: 'BLABLA')

    get :render_theme_file, params: {
      competition_handle: @competition.handle,
      locale: 'de',
      theme_file: 'index'
    }

    assert_equal 'FOOBAR BLABLA TEST', response.body
  end

  test '#render_theme_file renders css files without layout' do
    layout = theme_files(:aachen_open_layout)
    layout.update_attributes(content: "FOOBAR {{ content_for_layout }} TEST")

    get :render_theme_file, params: {
      competition_handle: @competition.handle,
      locale: 'de',
      theme_file: 'style',
      format: 'css'
    }

    assert_no_match /FOOBAR/, response.body
    assert_match /body {/, response.body
  end

  test '#render_theme_file over http with custom domain without force_ssl redirects to http' do
    @competition.custom_domain = 'bla.com'
    @competition.custom_domain_force_ssl = false
    @competition.save!

    get :render_theme_file, params: {
      competition_handle: @competition.handle,
      locale: 'de'
    }

    assert_redirected_to 'http://bla.com/ao14/de'
  end

  test '#render_theme_file over https with custom domain without force_ssl redirects to http' do
    @competition.custom_domain = 'bla.com'
    @competition.custom_domain_force_ssl = false
    @competition.save!

    use_https

    get :render_theme_file, params: {
      competition_handle: @competition.handle,
      locale: 'de'
    }

    assert_redirected_to 'http://bla.com/ao14/de'
  end

  test '#render_theme_file over http to custom domain without force_ssl does not redirect' do
    @competition.custom_domain = 'bla.com'
    @competition.custom_domain_force_ssl = false
    @competition.save!

    @request.host = @competition.custom_domain

    get :render_theme_file, params: {
      competition_handle: @competition.handle,
      locale: 'de'
    }

    assert_response :ok
  end

  test '#render_theme_file over https to custom domain without force_ssl does not redirect' do
    @competition.custom_domain = 'bla.com'
    @competition.custom_domain_force_ssl = false
    @competition.save!

    @request.host = @competition.custom_domain

    use_https

    get :render_theme_file, params: {
      competition_handle: @competition.handle,
      locale: 'de'
    }

    assert_response :ok
  end

  test '#render_theme_file over https to custom domain with force_ssl does not redirect' do
    @competition.custom_domain = 'bla.com'
    @competition.custom_domain_force_ssl = true
    @competition.save!

    @request.host = @competition.custom_domain

    use_https

    get :render_theme_file, params: {
      competition_handle: @competition.handle,
      locale: 'de'
    }

    assert_response :ok
  end

  test '#render_theme_file over https to custom domain without force_ssl does redirect' do
    @competition.custom_domain = 'bla.com'
    @competition.custom_domain_force_ssl = true
    @competition.save!

    @request.host = @competition.custom_domain

    get :render_theme_file, params: {
      competition_handle: @competition.handle,
      locale: 'de'
    }

    assert_redirected_to 'https://bla.com/ao14/de'
  end

  test '#render_theme_file over http with custom domain with force_ssl redirects to https' do
    @competition.custom_domain = 'bla.com'
    @competition.custom_domain_force_ssl = true
    @competition.save!

    get :render_theme_file, params: {
      competition_handle: @competition.handle,
      locale: 'de'
    }

    assert_redirected_to 'https://bla.com/ao14/de'
  end

  test '#render_theme_file over https with custom domain with force_ssl redirects to https' do
    @competition.custom_domain = 'bla.com'
    @competition.custom_domain_force_ssl = true
    @competition.save!

    use_https

    get :render_theme_file, params: {
      competition_handle: @competition.handle,
      locale: 'de'
    }

    assert_redirected_to 'https://bla.com/ao14/de'
  end
end
