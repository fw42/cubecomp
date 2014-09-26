require 'test_helper'

class LocaleTest < ActiveSupport::TestCase
  setup do
    @locale = locales(:aachen_open_german)
  end

  test 'validates presence and integrity of competition' do
    @locale.competition = nil
    assert_not_valid(@locale, :competition)

    @locale.competition_id = 17
    assert_not_valid(@locale, :competition)
  end

  test 'validates presence of handle' do
    @locale.handle = nil
    assert_not_valid(@locale, :handle)

    @locale.handle = ''
    assert_not_valid(@locale, :handle)
  end

  test 'validates uniqueness of handle scoped to competition' do
    new_locale = @locale.dup
    assert_not_valid(new_locale, :handle)

    new_locale.competition = competitions(:german_open)
    assert_valid(new_locale)
  end

  test 'validates inclusion of handle in list' do
    @locale.handle = 'blabla'
    assert_not_valid(@locale, :handle)

    @locale.handle = Locale::ALL.keys.first
    assert_valid(@locale)
  end

  test 'destroying locale destroys news items for that locale' do
    count = @locale.news.count
    assert_difference '@locale.news.count', -1 * count do
      assert_difference 'News.count', -1 * count do
        @locale.destroy
      end
    end
  end
end
