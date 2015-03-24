require 'test_helper'

class FrontPageControllerTest < ActionController::TestCase
  test "front page" do
    get :index
    assert_response :ok
  end

  test "front page shows competition iff it's published" do
    competition = competitions(:aachen_open)
    regexp = /#{Regexp.escape(competition.name)}/

    competition.update_attributes(published: true)
    get :index
    assert_response :ok
    assert_match regexp, response.body

    competition.update_attributes(published: false)
    get :index
    assert_response :ok
    assert_no_match regexp, response.body
  end
end
