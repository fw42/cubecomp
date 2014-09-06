require 'test_helper'

class Admin::CompetitionsControllerTest < ActionController::TestCase
  setup do
    @competition = competitions(:aachen_open)
  end

  test "#index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:competitions)
  end

  test "#new" do
    get :new
    assert_response :success
  end

  test "#create" do
    params = {
      city_name: 'Gütersloh',
      country_id: countries(:germany).id,
      handle: 'go15',
      name: 'German Open 2015',
      staff_email: 'german-open@cubecomp.de'
    }

    assert_difference('Competition.count') do
      post :create, competition: params
    end

    assert_redirected_to admin_competitions_path
    assert_attributes(params, Competition.find_by(handle: 'go15'))
  end

  test "#edit" do
    get :edit, id: @competition
    assert_response :success
  end

  test "#update" do
    params = {
      cc_orga: true,
      city_name: "Aix la chapelle",
      city_name_short: "AAC",
      country_id: countries(:germany).id,
      handle: 'aac14',
      name: 'Aachen Winter Open 2014',
      registration_open: true,
      staff_email: 'ao-winter@cubecomp.de',
      staff_name: 'aachen team',
      venue_address: 'rwth'
    }

    patch :update, id: @competition, competition: params

    assert_redirected_to edit_admin_competition_path(assigns(:competition))
    assert_attributes(params, @competition.reload)
  end

  test "#destroy" do
    assert_difference('Competition.count', -1) do
      delete :destroy, id: @competition
    end

    assert_redirected_to admin_competitions_path
  end
end
