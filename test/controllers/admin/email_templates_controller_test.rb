require 'test_helper'

class Admin::EmailTemplatesControllerTest < ActionController::TestCase
  setup do
    @template = email_templates(:aachen_open_confirmation)
    @competition = @template.competition
    login_as(@competition.users.first)
  end

  test '#index' do
    get :index, competition_id: @competition.id
    assert_response :success
    assert_not_nil assigns(:templates)
  end

  test '#index renders 404 with invalid competition id' do
    get :index, competition_id: 17
    assert_response :not_found
  end

  test '#new' do
    get :new, competition_id: @competition.id
    assert_response :success
  end

  test '#create' do
    params = { name: 'foo', content: 'bar', subject: 'foobar' }

    assert_difference('@competition.email_templates.count') do
      post :create, competition_id: @competition.id, email_template: params
    end

    assert_redirected_to admin_competition_email_templates_path(@competition)
    template = @competition.email_templates.last
    assert_equal 'foo', template.name
    assert_equal 'bar', template.content
    assert_equal 'foobar', template.subject
  end

  test '#edit' do
    get :edit, competition_id: @competition.id, id: @template.id
    assert_response :success
  end

  test '#update' do
    params = { name: 'foo', content: 'bar', subject: 'foobar' }

    patch :update, competition_id: @competition.id, id: @template.id, email_template: params

    assert_redirected_to admin_competition_email_templates_path(@competition)
    template = @competition.email_templates.last
    assert_equal 'foo', template.name
    assert_equal 'bar', template.content
    assert_equal 'foobar', template.subject
  end

  test '#destroy' do
    assert_difference('@competition.email_templates.count', -1) do
      delete :destroy, competition_id: @competition.id, id: @template.id
    end

    assert_redirected_to admin_competition_email_templates_path(@competition)
  end
end
