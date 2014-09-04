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
    assert_difference('Competition.count') do
      post :create, competition: {
        city_name: 'Gütersloh',
        country_id: countries(:germany).id,
        handle: 'go15',
        name: 'German Open 2015',
        staff_email: 'german-open@cubecomp.de'
      }
    end

    assert_redirected_to admin_competition_path(assigns(:competition))
    competition = Competition.find_by(handle: 'go15')
    assert_equal 'Gütersloh', competition.city_name
    assert_equal countries(:germany).id, competition.country.id
    assert_equal 'go15', competition.handle
    assert_equal 'German Open 2015', competition.name
    assert_equal 'german-open@cubecomp.de', competition.staff_email
  end

  test "#show" do
    get :show, id: @competition
    assert_response :success
  end

  test "#edit" do
    get :edit, id: @competition
    assert_response :success
  end

  test "#update" do
    patch :update, id: @competition, competition: {
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

    assert_redirected_to admin_competition_path(assigns(:competition))
    @competition.reload
    assert_equal true, @competition.cc_orga
    assert_equal 'Aix la chapelle', @competition.city_name
    assert_equal 'AAC', @competition.city_name_short
    assert_equal countries(:germany).id, @competition.country.id
    assert_equal 'aac14', @competition.handle
    assert_equal 'Aachen Winter Open 2014', @competition.name
    assert_equal true, @competition.registration_open
    assert_equal 'ao-winter@cubecomp.de', @competition.staff_email
    assert_equal 'aachen team', @competition.staff_name
    assert_equal 'rwth', @competition.venue_address
  end

  test "#destroy" do
    assert_difference('Competition.count', -1) do
      delete :destroy, id: @competition
    end

    assert_redirected_to admin_competitions_path
  end
end
