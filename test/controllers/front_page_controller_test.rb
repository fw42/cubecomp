require 'test_helper'

class FrontPageControllerTest < ActionController::TestCase
  setup do
    @competition = competitions(:aachen_open)
    @main_domain = "cubecomp.de"
  end

  test "front page" do
    get :index
    assert_response :ok
  end

  test "#index shows competition iff it's published" do
    regexp = /#{Regexp.escape(@competition.name)}/

    @competition.update_attributes(published: true)
    get :index
    assert_response :ok
    assert_match regexp, response.body

    @competition.update_attributes(published: false)
    get :index
    assert_response :ok
    assert_no_match regexp, response.body
  end

  test "#index on unknown domain with http redirects to https if main_domain has ssl" do
    mock_main_domain(true)
    get :index
    assert_response :redirect
    assert_redirected_to "https://#{@main_domain}/"
  end

  test "#index on unknown domain with http does not redirect to https if main_domain does not have ssl" do
    mock_main_domain(false)
    get :index
    assert_response :redirect
    assert_redirected_to "http://#{@main_domain}/"
  end

  test "#index on unknown domain with http does not redirect to https if main_domain protocol is unspecified" do
    mock_main_domain(nil)
    get :index
    assert_response :redirect
    assert_redirected_to "http://#{@main_domain}/"
  end

  test "#index on main_domain with http redirects to https if main_domain has ssl" do
    @request.host = @main_domain
    mock_main_domain(true)
    get :index
    assert_response :redirect
    assert_redirected_to "https://#{@main_domain}/"
  end

  test "#index on main_domain with http does not redirect to https if main_domain does not have ssl" do
    @request.host = @main_domain
    mock_main_domain(false)
    get :index
    assert_response :ok
  end

  test "#index on main_domain with http does not redirect to https if main_domain protocol is unspecified" do
    @request.host = @main_domain
    mock_main_domain(nil)
    get :index
    assert_response :ok
  end

  test "#index on main_domain with https redirects to http if main_domain has no ssl" do
    @request.host = @main_domain
    use_https
    mock_main_domain(false)
    get :index
    assert_response :redirect
    assert_redirected_to "http://#{@main_domain}/"
  end

  test "#index on main_domain with https does not redirect to http if main_domain does have ssl" do
    @request.host = @main_domain
    use_https
    mock_main_domain(true)
    get :index
    assert_response :ok
  end

  test "#index on main_domain with https does not redirect to http if main_domain protocol is unspecified" do
    @request.host = @main_domain
    use_https
    mock_main_domain(nil)
    get :index
    assert_response :ok
  end

  test "#index on custom domain with http redirects to https if custom domain has ssl" do
    custom_domain = "foobar.com"
    @competition.custom_domain = custom_domain
    @competition.custom_domain_force_ssl = true
    @competition.save!
    @request.host = custom_domain
    get :index
    assert_response :redirect
    assert_redirected_to "https://#{custom_domain}/"
  end

  test "#index on custom domain with http does not redirect to https if custom domain doesn't have ssl" do
    custom_domain = "foobar.com"
    @competition.custom_domain = custom_domain
    @competition.custom_domain_force_ssl = false
    @competition.save!
    @request.host = custom_domain
    get :index
    assert_response :ok
  end

  test "#index on custom domain with https does not redirect to http if custom domain has ssl" do
    custom_domain = "foobar.com"
    @competition.custom_domain = custom_domain
    @competition.custom_domain_force_ssl = true
    @competition.save!
    @request.host = custom_domain
    use_https
    get :index
    assert_response :ok
  end

  test "#index on custom domain with https does redirect to http if custom domain does not have ssl" do
    custom_domain = "foobar.com"
    @competition.custom_domain = custom_domain
    @competition.custom_domain_force_ssl = false
    @competition.save!
    @request.host = custom_domain
    use_https
    get :index
    assert_response :redirect
    assert_redirected_to "http://#{custom_domain}/"
  end

  test "#index on main_domain shows competitions with custom_domain" do
    regexp = /#{Regexp.escape(@competition.name)}/

    @competition.published = true
    @competition.custom_domain = "foobar.com"
    @competition.save!

    @request.host = @competition.custom_domain
    get :index
    assert_response :ok
    assert_match regexp, response.body
  end

  test "#index on custom_domain does not show competitions with other custom_domain" do
    regexp = /#{Regexp.escape(@competition.name)}/

    @competition.published = true
    @competition.custom_domain = "foobar.com"
    @competition.save!

    other_competition = competitions(:german_open)
    other_competition.custom_domain = "bla.com"
    other_competition.save!

    @request.host = other_competition.custom_domain
    get :index
    assert_response :ok
    refute_match regexp, response.body
  end

  test "#index on custom_domain does not show competitions with no custom_domain" do
    other_competition = competitions(:german_open)
    other_competition.published = true
    other_competition.save!

    regexp = /#{Regexp.escape(other_competition.name)}/

    @competition.published = true
    @competition.custom_domain = "foobar.com"
    @competition.save!

    @request.host = @competition.custom_domain
    get :index
    assert_response :ok
    refute_match regexp, response.body
  end

  private

  def mock_main_domain(ssl)
    Cubecomp::Application.config.expects(:main_domain).returns(@main_domain)

    protocol = if ssl
      "https://"
    elsif !ssl.nil?
      "http://"
    end

    Cubecomp::Application.config.expects(:main_domain_protocol).returns(protocol)
  end
end
