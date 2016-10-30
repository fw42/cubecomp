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
    new_locale = locales(:aachen_open_english).dup
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

  test 'deleting a default locale nullifies the default_locale_id column on competition' do
    competition = @locale.competition
    competition.default_locale = @locale
    competition.save!

    @locale.destroy!
    assert_equal nil, competition.reload.default_locale_id
  end

  test 'locales are a subset of available I18n locales' do
    assert_equal [], Locale::ALL.keys - I18n.available_locales.map(&:to_s)
  end

  test 'all I18n locale files have the same keys' do
    locales = Dir[Rails.root.join('config/locales/*.yml')]
    locales = locales.map do |filename|
      hash = YAML.load(File.read(filename))
      strip_values(hash)
    end

    locales.each do |locale1|
      locales.each do |locale2|
        assert_equal locale1.values, locale2.values,
          "Locale #{locale1.keys} and #{locale2.keys} don't have the same keys"
      end
    end
  end

  private

  def strip_values(hash)
    if hash.is_a?(Hash)
      Hash[hash.map{ |k, v| [ k, strip_values(v) ] }]
    elsif hash.is_a?(Array)
      hash.map{ |value| strip_values(value) }
    end
  end
end
