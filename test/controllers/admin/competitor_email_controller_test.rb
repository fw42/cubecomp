require 'test_helper'

class Admin::CompetitorEmailControllerTest < ActionController::TestCase
  setup do
    @competitor = competitors(:flo_aachen_open)
    @competition = @competitor.competition
    login_as(@competition.users.first)
  end

  teardown do
    ActionMailer::Base.deliveries.clear
  end

  test '#new' do
    get :new, competition_id: @competition.id, id: @competitor.id
    assert_response :success
    assert_not_nil assigns(:competitor)
    assert_not_nil assigns(:email)
  end

  test '#create sends an email' do
    params = {
      "subject" => "[Aachen Open 2014] Welcome!",
      "content" => "Hello!"
    }

    post :create, competition_id: @competition.id, id: @competitor.id, competitor_email: params
    assert_redirected_to admin_competition_competitors_path(@competition)

    emails = ActionMailer::Base.deliveries
    assert_equal 1, emails.size
    email = emails.first
    assert_equal [@competitor.email], email.to
    assert_equal [Cubecomp::Application.config.email_address], email.from
    assert_equal [@competition.staff_email], email.reply_to
    assert_equal params['subject'], email.subject
    assert_equal params['content'], email.body.to_s
  end

  test '#create sends an email and cc the orga team' do
    params = {
      "subject" => "[Aachen Open 2014] Welcome!",
      "content" => "Hello!"
    }

    @competition.update_attributes(cc_staff: true)
    post :create, competition_id: @competition.id, id: @competitor.id, competitor_email: params

    emails = ActionMailer::Base.deliveries
    assert_equal 1, emails.size
    email = emails.first
    assert_equal [@competition.staff_email], email.cc
  end

  test '#create with activate confirms the competitor and sets confirmation_email_sent to true' do
    params = {
      "subject" => "[Aachen Open 2014] Welcome!",
      "content" => "Hello!"
    }

    @competitor.update_attributes(state: 'new', confirmation_email_sent: false)
    post :create, competition_id: @competition.id, id: @competitor.id, competitor_email: params, activate: 'activate'
    assert_redirected_to admin_competition_competitors_path(@competition)
    @competitor.reload
    assert_equal 'confirmed', @competitor.state
    assert_equal true, @competitor.confirmation_email_sent
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
