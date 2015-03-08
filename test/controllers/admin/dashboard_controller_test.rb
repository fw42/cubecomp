require 'test_helper'

class Admin::DashboardControllerTest < ActionController::TestCase
  setup do
    @competition = competitions(:aachen_open)
    @user = @competition.users.first
    login_as(@user)
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

  test "#index shows financial overview" do
    regexp = /<table class='default-table financial-overview'>/

    FinancialService.any_instance.expects(:total_count).returns(17)
    get :index, competition_id: @competition.id
    assert_match regexp, response.body

    FinancialService.any_instance.expects(:total_count).returns(0)
    get :index, competition_id: @competition.id
    assert_no_match regexp, response.body
  end

  test "#index shows events with registration limits iff there are such" do
    regexp = /<table class='default-table progress'>/

    get :index, competition_id: @competition.id
    assert_match regexp, response.body

    @competition.events.each(&:destroy!)
    get :index, competition_id: @competition.id
    assert_no_match regexp, response.body
  end

  test "#index shows getting started users tip iff the competition has no users and current user is admin" do
    regexp = /There are no users with permission to organize this competition/

    UserPolicy.any_instance.expects(:admin_user_menu?).at_least_once.returns(false)
    get :index, competition_id: @competition.id
    assert_no_match regexp, response.body

    UserPolicy.any_instance.expects(:admin_user_menu?).at_least_once.returns(true)
    @competition.permissions.each(&:destroy!)
    get :index, competition_id: @competition.id
    assert_match regexp, response.body

    UserPolicy.any_instance.expects(:admin_user_menu?).at_least_once.returns(false)
    get :index, competition_id: @competition.id
    assert_no_match regexp, response.body
  end

  test "#index shows getting started owner tip iff the competition has no owner" do
    regexp = /You haven't specified the owner of this competition yet/

    Competition.any_instance.expects(:owner).at_least_once.returns(nil)
    get :index, competition_id: @competition.id
    assert_match regexp, response.body

    Competition.any_instance.expects(:owner).at_least_once.returns(@user)
    get :index, competition_id: @competition.id
    assert_no_match regexp, response.body
  end

  test "#index shows getting started events tip iff the competition has no events that are for registration" do
    regexp = /You haven't created any events yet/

    get :index, competition_id: @competition.id
    assert_no_match regexp, response.body

    @competition.events.each(&:destroy!)
    get :index, competition_id: @competition.id
    assert_match regexp, response.body
  end

  test "#index shows getting started theme tip iff the competition has no theme files" do
    regexp = /Your website has no theme yet/

    get :index, competition_id: @competition.id
    assert_no_match regexp, response.body

    @competition.theme_files.each(&:destroy!)
    get :index, competition_id: @competition.id
    assert_match regexp, response.body
  end
end
