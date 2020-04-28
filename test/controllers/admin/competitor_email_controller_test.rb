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
    get :new, params: { competition_id: @competition.id, id: @competitor.id }
    assert_response :success
  end

  test '#new for locals' do
    @competitor.update(local: true)
    get :new, params: { competition_id: @competition.id, id: @competitor.id }
    assert_response :success
  end

  test '#create sends an email' do
    email_params = {
      "subject" => "[Aachen Open 2014] Welcome!",
      "content" => "Hello!"
    }

    post :create, params: {
      competition_id: @competition.id,
      id: @competitor.id,
      competitor_email: email_params
    }

    assert_redirected_to admin_competition_competitors_path(@competition)

    emails = ActionMailer::Base.deliveries
    assert_equal 1, emails.size
    email = emails.first
    assert_equal [@competitor.email], email.to
    assert_equal [Cubecomp::Application.config.email_address], email.from
    assert_equal [@competition.staff_email], email.reply_to
    assert_equal email_params['subject'], email.subject
    assert_equal email_params['content'], email.body.to_s
  end

  test '#create sends an email and cc the orga team' do
    email_params = {
      "subject" => "[Aachen Open 2014] Welcome!",
      "content" => "Hello!"
    }

    @competition.update(cc_staff: true)

    post :create, params: {
      competition_id: @competition.id,
      id: @competitor.id,
      competitor_email: email_params
    }

    emails = ActionMailer::Base.deliveries
    assert_equal 1, emails.size
    email = emails.first
    assert_equal [@competition.staff_email], email.cc
  end

  test '#create with activate confirms the competitor and sets confirmation_email_sent to true' do
    email_params = {
      "subject" => "[Aachen Open 2014] Welcome!",
      "content" => "Hello!"
    }

    @competitor.update(state: 'new', confirmation_email_sent: false)

    post :create, params: {
      competition_id: @competition.id,
      id: @competitor.id,
      competitor_email: email_params,
      activate: 'activate'
    }

    assert_redirected_to admin_competition_competitors_path(@competition)
    @competitor.reload
    assert_equal 'confirmed', @competitor.state
    assert_equal true, @competitor.confirmation_email_sent
  end

  test '#render_template' do
    template = email_templates(:aachen_open_confirmation)

    get :render_template,
      format: :json,
      params: {
        competition_id: @competition.id,
        id: @competitor.id,
        email_template_id: template.id
      }

    response = JSON.parse(@response.body)
    assert_equal({
      "subject" => "[Aachen Open 2014] Registration confirmation",
      "content" => "Welcome Florian Weingarten, see you, Regular One"
    }, response)
  end
end
