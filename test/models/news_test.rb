require 'test_helper'

class NewsTest < ActiveSupport::TestCase
  setup do
    @news = news(:aachen_open_registration_open)
  end

  test 'validates presence and integrity of competition' do
    @news.competition = nil
    assert_not_valid(@news, :competition)

    @news.competition_id = 1234
    assert_not_valid(@news, :competition)
  end

  test 'validates presence and integrity of locale' do
    @news.locale = nil
    assert_not_valid(@news, :locale)

    @news.locale_id = 123
    assert_not_valid(@news, :locale)
  end

  test 'validates presence of time' do
    @news.time = nil
    assert_not_valid(@news, :time)

    @news.time = ''
    assert_not_valid(@news, :time)
  end

  test 'validates presence of text' do
    @news.text = nil
    assert_not_valid(@news, :text)

    @news.text = ''
    assert_not_valid(@news, :text)
  end
end
