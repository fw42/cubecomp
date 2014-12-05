require 'test_helper'

class CompetitorsControllerTest < ActionController::TestCase
  test "#search" do
    WcaGateway.any_instance.expects(:search_by_id).returns([])
    get :search, q: "2014bla"
    assert_response :ok
    assert_equal "[]", response.body
  end
end
