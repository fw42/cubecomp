require 'test_helper'

class Admin::EmailTemplatesControllerTest < ActionController::TestCase
  setup do
    @template = email_templates(:aachen_open_confirmation)
    @competition = @template.competition
    login_as(@competition.users.first)
  end

  test '#index' do
    get :index, params: { competition_id: @competition.id }
    assert_response :success
  end

  test '#index renders 404 with invalid competition id' do
    get :index, params: { competition_id: 17 }
    assert_response :not_found
  end

  test '#new' do
    get :new, params: { competition_id: @competition.id }
    assert_response :success
  end

  test '#create' do
    email_params = { name: 'foo', content: 'bar', subject: 'foobar' }

    assert_difference('@competition.email_templates.count') do
      post :create, params: {
        competition_id: @competition.id,
        email_template: email_params
      }
    end

    assert_redirected_to admin_competition_email_templates_path(@competition)
    template = @competition.email_templates.last
    assert_equal 'foo', template.name
    assert_equal 'bar', template.content
    assert_equal 'foobar', template.subject
  end

  test '#edit' do
    get :edit, params: { competition_id: @competition.id, id: @template.id }
    assert_response :success
  end

  test '#update' do
    email_params = { name: 'foo', content: 'bar', subject: 'foobar' }

    patch :update, params: {
      competition_id: @competition.id,
      id: @template.id,
      email_template: email_params
    }

    assert_redirected_to admin_competition_email_templates_path(@competition)
    template = @competition.email_templates.last
    assert_equal 'foo', template.name
    assert_equal 'bar', template.content
    assert_equal 'foobar', template.subject
  end

  test '#destroy' do
    assert_difference('@competition.email_templates.count', -1) do
      delete :destroy, params: {
        competition_id: @competition.id,
        id: @template.id
      }
    end

    assert_redirected_to admin_competition_email_templates_path(@competition)
  end

  test '#import_templates_form' do
    get :import_templates_form, params: { competition_id: @competition.id }
    assert_response :success
  end

  test '#import_templates' do
    competition = competitions(:german_open)
    login_as(competition.users.first)

    diff = -competition.email_templates.count + @competition.email_templates.count

    assert_difference 'competition.email_templates.count', diff do
      post :import_templates, params: {
        competition_id: competition.id,
        from_competition_id: @competition.id
      }
    end

    assert_email_templates_equal @competition.email_templates, competition.email_templates
  end

  test '#import_templates can only import templates that the current user has permission for' do
    from_competition = competitions(:german_open)

    UserPolicy.any_instance.expects(:login?)
      .with{ |competition| competition.id == @competition.id }
      .returns(true)

    UserPolicy.any_instance.expects(:login?)
      .with{ |competition| competition.id == from_competition.id }
      .returns(false)

    assert_no_difference 'EmailTemplate.count' do
      post :import_templates, params: {
        competition_id: @competition.id,
        from_competition_id: from_competition.id
      }
    end

    assert_response :forbidden
  end
end
