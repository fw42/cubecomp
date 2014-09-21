require 'test_helper'

class Admin::CompetitorsControllerTest < ActionController::TestCase
  setup do
    @competitor = competitors(:flo_aachen_open)
    @competition = @competitor.competition
    login_as(@competition.users.first)

    @new_competitor_params = {
      admin_comment: 'this guy is awesome',
      birthday: '1980-01-01',
      country_id: countries(:germany).id,
      email: 'bob@cubecomp.de',
      first_name: 'bob',
      last_name: 'bobsen',
      free_entrance: true,
      free_entrance_reason: 'free moneys!',
      local: true,
      paid: true,
      paid_comment: 'moneys!',
      staff: true,
      user_comment: 'hello',
      wca: '2000BOB',
      male: true
    }

    @update_params = {
      admin_comment: 'this guy is awesome',
      birthday: '1980-01-01',
      country_id: countries(:germany).id,
      email: 'bob@cubecomp.de',
      first_name: 'bob',
      last_name: 'bobsen',
      free_entrance: true,
      free_entrance_reason: 'free moneys!',
      local: true,
      paid: true,
      paid_comment: 'moneys!',
      staff: true,
      user_comment: 'hello',
      wca: '2000BOB'
    }
  end

  test "#index" do
    get :index, competition_id: @competition.id
    assert_response :success
    assert_not_nil assigns(:competitors)
  end

  test "#index renders 404 with invalid competition id" do
    get :index, competition_id: 17
    assert_response :not_found
  end

  test "#index without login permission renders 401" do
    mock_login_not_allowed(@competition)
    get :index, competition_id: @competition.id
    assert_response :unauthorized
  end

  test "#new" do
    get :new, competition_id: @competition.id
    assert_response :success
  end

  test "#new without login permission renders 401" do
    mock_login_not_allowed(@competition)
    get :new, competition_id: @competition.id
    assert_response :unauthorized
  end

  test "#create" do
    assert_difference '@competition.competitors.count', +1 do
      post :create, competition_id: @competition.id, competitor: @new_competitor_params
    end

    assert_redirected_to admin_competition_competitor_path(@competition.id, assigns(:competitor))
    bob = @competition.competitors.find_by(wca: '2000BOB')
    assert_attributes(@new_competitor_params.except(:birthday), bob)
    assert_equal Date.parse(@new_competitor_params[:birthday]), bob.birthday
  end

  test "#create without login permission renders 401" do
    mock_login_not_allowed(@competition)

    assert_no_difference 'Competitor.count' do
      post :create, competition_id: @competition.id, competitor: @new_competitor_params
    end

    assert_response :unauthorized
  end

  test "#show" do
    get :show, competition_id: @competition.id, id: @competitor.id
    assert_response :success
  end

  test "#show without login permission renders 401" do
    mock_login_not_allowed(@competition)
    get :show, competition_id: @competition.id, id: @competitor.id
    assert_response :unauthorized
  end

  test "#edit" do
    get :edit, competition_id: @competition.id, id: @competitor.id
    assert_response :success
  end

  test "#edit without login permission renders 401" do
    mock_login_not_allowed(@competition)
    get :edit, competition_id: @competition.id, id: @competitor.id
    assert_response :unauthorized
  end

  test "#update" do
    patch :update, competition_id: @competition.id, id: @competitor.id, competitor: @update_params

    assert_redirected_to admin_competition_competitor_path(@competition.id, assigns(:competitor))
    @competitor.reload
    assert_attributes(@update_params.except(:birthday), @competitor)
    assert_equal Date.parse(@update_params[:birthday]), @competitor.birthday
  end

  test "#update without login permission renders 401" do
    mock_login_not_allowed(@competition)
    patch :update, competition_id: @competition.id, id: @competitor.id, competitor: @update_params
    assert_response :unauthorized
  end

  test "#destroy" do
    assert_difference '@competition.competitors.count', -1 do
      delete :destroy, competition_id: @competition.id, id: @competitor.id
    end

    assert_redirected_to admin_competition_competitors_path(@competition.id)
  end

  test "#destroy without login permission renders 401" do
    mock_login_not_allowed(@competition)

    assert_no_difference 'Competitor.count' do
      delete :destroy, competition_id: @competition.id, id: @competitor.id
    end

    assert_response :unauthorized
  end
end
