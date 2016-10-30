require 'test_helper'

class WcaControllerTest < ActionController::TestCase
  test "#autocomplete" do
    get :autocomplete, format: :json, q: "2014BLABLA"
    assert_response :ok
    assert_equal "[]", response.body
  end

  test '#autocomplete requires query param and a minimum query length' do
    get :autocomplete, format: :json
    assert_equal "{\"error\":\"invalid query\"}", response.body

    get :autocomplete, format: :json, q: 'x'
    assert_equal "{\"error\":\"query needs to be at least 6 characters\"}", response.body
  end
end
