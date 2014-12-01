require 'test_helper'

class ErrorsForAssociationsTest < ActionController::TestCase
  tests Admin::CompetitorsController

  setup do
    @competition = competitions(:aachen_open)
    login_as(users(:admin))
  end

  test 'error on association is also set on the _id field' do
    post :create, competition_id: @competition.id, competitor: {
      first_name: 'Bob'
    }

    label_error = '<div class="field_with_errors"><label for="competitor_country">Country:</label></div>'
    select_error = '<div class="field_with_errors"><select name="competitor[country_id]" id="competitor_country_id"'

    assert @response.body.include?(label_error), 'should include error styling for the association'
    assert @response.body.include?(select_error), 'should include error styling for the foreign key'
  end
end
