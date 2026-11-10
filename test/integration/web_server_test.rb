require 'test_helper'
require 'net/http'
require 'puma'

# Serves real HTTP requests through puma, the production web server.
# Other tests go through Rack::Test, which never writes a response to a
# socket, so it can't catch the web server choking on a response. That
# happened with unicorn, which crashed on pages setting multiple cookies
# (Rack 3 sends those as an Array header value).
class WebServerTest < ActiveSupport::TestCase
  setup do
    @competition = competitions(:aachen_open)
    @competition.theme_files.create!(
      filename: 'registration.html',
      content: '{{ registration_form }}'
    )

    @server = Puma::Server.new(
      Rails.application,
      nil,
      min_threads: 1,
      max_threads: 1,
      log_writer: Puma::LogWriter.null
    )
    @server.add_tcp_listener('127.0.0.1', 0)
    @server.run

    WebMock.disable_net_connect!(allow_localhost: true)
  end

  teardown do
    WebMock.disable_net_connect!
    @server&.stop(true)
  end

  test 'competition area page that sets multiple cookies' do
    # The CSRF token in the registration form writes the session, and the
    # competition area always sets the locale cookie: two Set-Cookie headers
    response = with_csrf_protection { get("/#{@competition.handle}/de/registration") }

    assert_equal '200', response.code
    cookies = response.get_fields('set-cookie')
    assert_equal 2, cookies.size, cookies.inspect
    assert cookies.any? { |cookie| cookie.start_with?('locale=de;') }, cookies.inspect
    assert cookies.any? { |cookie| cookie.start_with?('_cubecomp_session=') }, cookies.inspect
  end

  private

  def get(path)
    port = @server.connected_ports.first
    Net::HTTP.start('127.0.0.1', port, read_timeout: 10) do |http|
      http.get(path)
    end
  end
end
