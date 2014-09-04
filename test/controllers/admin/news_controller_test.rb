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
    assert_difference('News.count') do
      post :create, competition_id: @competition, news: {
        locale: @news.locale,
        text: @news.text,
        time: @news.time
      }
    end

    assert_redirected_to admin_news_path(assigns(:news))
  end

  test "#edit" do
    get :edit, id: @news
    assert_response :success
  end

  test "#update" do
    patch :update, id: @news, news: {
      locale: @news.locale,
      text: @news.text,
      time: @news.time
    }

    assert_redirected_to admin_news_path(assigns(:news))
  end

  test "#destroy" do
    assert_difference('News.count', -1) do
      delete :destroy, id: @news
    end

    assert_redirected_to admin_competition_news_index_path(@competition)
  end
end
