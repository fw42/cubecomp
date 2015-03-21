require 'test_helper'

class Liquid::Filters::I18nTest < ActiveSupport::TestCase
  class Filters
    attr_writer :context
    include Liquid::Filters::I18n
  end

  setup do
    @context = Liquid::Context.new
    @filters = Filters.new
    @filters.context = @context
    @context.registers[:locale] = locales(:aachen_open_german)
  end

  test "#translate filter" do
    assert_equal 'Anmeldung erfolgreich. Du wirst bald eine Bestätigung per E-Mail erhalten.',
      @filters.translate('registration.flash_success')

    @context.registers[:locale] = locales(:aachen_open_english)
    assert_equal 'Registration successful. You will receive a confirmation email soon.',
      @filters.translate('registration.flash_success')

    assert_equal 'Anmeldung erfolgreich. Du wirst bald eine Bestätigung per E-Mail erhalten.',
      @filters.translate('registration.flash_success', 'de')
  end

  test "#translate_date filter" do
    assert_equal "21.03.2015", @filters.translate_date(Time.parse("2015-03-21").to_date)
    assert_equal "21. März 2015", @filters.translate_date(Time.parse("2015-03-21").to_date, "%d. %B %Y")
  end
end
