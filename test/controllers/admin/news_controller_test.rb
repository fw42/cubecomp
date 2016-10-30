require 'test_helper'

class Admin::NewsControllerTest < ActionController::TestCase
  setup do
    @news = news(:aachen_open_registration_open)
    @competition = @news.competition
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
    news_params = {
      locale_id: @competition.locales.first.id,
      text: 'hello',
      'time(1i)' => '2014',
      'time(2i)' => '9',
      'time(3i)' => '11',
      'time(4i)' => '11',
      'time(5i)' => '30'
    }

    assert_difference('@competition.news.count') do
      post :create, params: {
        competition_id: @competition.id,
        news: news_params
      }
    end

    assert_redirected_to admin_competition_news_index_path(@competition)
    news = @competition.news.last
    assert_equal @competition.locales.first, news.locale
    assert_equal Time.parse('2014-09-11 11:30 UTC'), news.time
  end

  test '#edit' do
    get :edit, params: {
      competition_id: @competition.id,
      id: @news.id
    }

    assert_response :success
  end

  test '#update' do
    news_params = {
      locale_id: @competition.locales.first.id,
      text: 'hello',
      'time(1i)' => '2014',
      'time(2i)' => '9',
      'time(3i)' => '11',
      'time(4i)' => '11',
      'time(5i)' => '30'
    }

    patch :update, params: {
      competition_id: @competition.id,
      id: @news.id,
      news: news_params
    }

    assert_redirected_to admin_competition_news_index_path(@competition)
    news = @competition.news.last
    assert_equal @competition.locales.first, news.locale
    assert_equal Time.parse('2014-09-11 11:30 UTC'), news.time
  end

  test '#destroy' do
    assert_difference('@competition.news.count', -1) do
      delete :destroy, params: {
        competition_id: @competition.id,
        id: @news.id
      }
    end

    assert_redirected_to admin_competition_news_index_path(@competition)
  end
end
