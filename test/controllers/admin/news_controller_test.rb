require 'test_helper'

class Admin::NewsControllerTest < ActionController::TestCase
  setup do
    @news = news(:aachen_open_registration_open)
    @competition = @news.competition
  end

  test "#index" do
    get :index, competition_id: @competition
    assert_response :success
    assert_not_nil assigns(:news)
  end

  test "#new" do
    get :new, competition_id: @competition
    assert_response :success
  end

  test "#create" do
    params = {
      locale: 'de',
      text: 'hello',
      time: '2014-09-04'
    }

    assert_difference('@competition.news.count') do
      post :create, competition_id: @competition, news: params
    end

    assert_redirected_to admin_news_path(assigns(:news))
    news = @competition.news.last
    assert_attributes(params.except(:time), news)
    assert_equal Time.parse(params[:time]), news.time
  end

  test "#edit" do
    get :edit, id: @news
    assert_response :success
  end

  test "#update" do
    params = {
      locale: 'de',
      text: 'hello',
      time: '2014-09-04'
    }

    patch :update, id: @news, news: params

    assert_redirected_to admin_news_path(assigns(:news))
    news = @competition.news.last
    assert_attributes(params.except(:time), news)
    assert_equal Time.parse(params[:time]), news.time
  end

  test "#destroy" do
    assert_difference('@competition.news.count', -1) do
      delete :destroy, id: @news
    end

    assert_redirected_to admin_competition_news_index_path(@competition)
  end
end
