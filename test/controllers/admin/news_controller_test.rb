require 'test_helper'

class Admin::NewsControllerTest < ActionController::TestCase
  setup do
    @news = news(:aachen_open_registration_open)
    @competition = @news.competition
    login_as(@competition.users.first)
  end

  test '#index' do
    get :index, competition_id: @competition.id
    assert_response :success
    assert_not_nil assigns(:news)
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
    params = {
      locale_id: @competition.locales.first.id,
      text: 'hello',
      'time(1i)' => '2014',
      'time(2i)' => '9',
      'time(3i)' => '11',
      'time(4i)' => '11',
      'time(5i)' => '30'
    }

    assert_difference('@competition.news.count') do
      post :create, competition_id: @competition.id, news: params
    end

    assert_redirected_to admin_competition_news_index_path(@competition)
    news = @competition.news.last
    assert_equal @competition.locales.first, news.locale
    assert_equal Time.parse('2014-09-11 11:30'), news.time
  end

  test '#edit' do
    get :edit, competition_id: @competition.id, id: @news.id
    assert_response :success
  end

  test '#update' do
    params = {
      locale_id: @competition.locales.first.id,
      text: 'hello',
      'time(1i)' => '2014',
      'time(2i)' => '9',
      'time(3i)' => '11',
      'time(4i)' => '11',
      'time(5i)' => '30'
    }

    patch :update, competition_id: @competition.id, id: @news.id, news: params

    assert_redirected_to admin_competition_news_index_path(@competition)
    news = @competition.news.last
    assert_equal @competition.locales.first, news.locale
    assert_equal Time.parse('2014-09-11 11:30'), news.time
  end

  test '#destroy' do
    assert_difference('@competition.news.count', -1) do
      delete :destroy, competition_id: @competition.id, id: @news.id
    end

    assert_redirected_to admin_competition_news_index_path(@competition)
  end
end
