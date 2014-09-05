require 'test_helper'

class Admin::CompetitorsControllerTest < ActionController::TestCase
  setup do
    @competitor = competitors(:flo_aachen_open)
    @competition = @competitor.competition
  end

  test "#index" do
    get :index, competition_id: @competition.id
    assert_response :success
    assert_not_nil assigns(:competitors)
  end

  test "#new" do
    get :new, competition_id: @competition.id
    assert_response :success
  end

  test "#create" do
    params = {
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

    assert_difference('@competition.competitors.count') do
      post :create, competition_id: @competition.id, competitor: params
    end

    assert_redirected_to admin_competitor_path(assigns(:competitor))
    bob = @competition.competitors.find_by(wca: '2000BOB')
    assert_attributes(params.except(:birthday), bob)
    assert_equal Date.parse(params[:birthday]), bob.birthday
  end

  test "#show" do
    get :show, id: @competitor
    assert_response :success
  end

  test "#edit" do
    get :edit, id: @competitor
    assert_response :success
  end

  test "#update" do
    params = {
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

    patch :update, id: @competitor, competitor: params

    assert_redirected_to admin_competitor_path(assigns(:competitor))
    @competitor.reload
    assert_attributes(params.except(:birthday), @competitor)
    assert_equal Date.parse(params[:birthday]), @competitor.birthday
  end

  test "should destroy competitor" do
    assert_difference('@competition.competitors.count', -1) do
      delete :destroy, id: @competitor
    end

    assert_redirected_to admin_competition_competitors_path(@competition)
  end
end
