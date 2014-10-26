require 'test_helper'

class Admin::CompetitorEmailControllerTest < ActionController::TestCase
  setup do
    @competitor = competitors(:flo_aachen_open)
    @competition = @competitor.competition
    login_as(@competition.users.first)
  end

  test '#new' do
    get :new, competition_id: @competition.id, id: @competitor.id
    assert_response :success
    assert_not_nil assigns(:competitor)
    assert_not_nil assigns(:email)
  end

  test '#create' do
    # TODO
  end

  test '#render_template' do
    template = email_templates(:aachen_open_confirmation)

    get :render_template,
      format: :json,
      competition_id: @competition.id,
      id: @competitor.id,
      email_template_id: template.id

    response = JSON.parse(@response.body)
    assert_equal({
      "subject" => "[Aachen Open 2014] Registration confirmation",
      "content" => "Welcome Florian Weingarten, see you, Regular One"
    }, response)
  end
end
