require 'test_helper'

class Admin::DashboardControllerTest < ActionController::TestCase
  setup do
    @competition = competitions(:aachen_open)
    login_as(@competition.users.first)
  end

  test '#index' do
    get :index, competition_id: @competition.id
    assert_response :ok
  end

  test '#index renders 404 with invalid competition id' do
    get :index, competition_id: 17
    assert_response :not_found
  end

  test '#index shows admin menu if #admin_user_menu? is true' do
    UserPolicy.any_instance.expects(:admin_user_menu?).at_least_once.returns(true)
    get :index, competition_id: @competition.id
    assert_template 'admin/_navigation_item'
    assert_match /href="#{Regexp.escape(admin_competitions_path)}"/, response.body
    assert_match /href="#{Regexp.escape(admin_users_path)}"/, response.body
    assert_match /href="#{Regexp.escape(admin_themes_path)}"/, response.body
  end

  test '#index does not show admin menu if #admin_user_menu? is false' do
    UserPolicy.any_instance.expects(:admin_user_menu?).at_least_once.returns(false)
    get :index, competition_id: @competition.id
    refute_match /href="#{Regexp.escape(admin_competitions_path)}"/, response.body
    refute_match /href="#{Regexp.escape(admin_users_path)}"/, response.body
    refute_match /href="#{Regexp.escape(admin_themes_path)}"/, response.body
  end

  test '#index shows dropdown menu if UserPolicy#competitions returns more than one' do
    UserPolicy.any_instance.expects(:competitions).at_least_once.returns(Competition.all)
    get :index, competition_id: @competition.id
    Competition.all.each do |competition|
      assert_match /<select/, response.body
      assert_match /<option value="#{Regexp.escape(admin_competition_dashboard_index_path(competition.id))}"/,
        response.body
    end
  end

  test '#index shows no dropdown menu if UserPolicy#competitiosn returns only one competition' do
    UserPolicy.any_instance.expects(:competitions).at_least_once.returns([@competition])
    get :index, competition_id: @competition.id
    refute_match /<select/, response.body
    refute_match /<option/, response.body
  end
end
