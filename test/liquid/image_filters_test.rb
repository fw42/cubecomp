require 'test_helper'

class ImageFiltersTest < ActiveSupport::TestCase
  class Filters
    attr_writer :context
    include ImageFilters
  end

  setup do
    @context = Liquid::Context.new
    @filters = Filters.new
    @filters.context = @context
    @context.registers[:competition] = competitions(:aachen_open)
    @file = theme_files(:aachen_open_logo)
  end

  test '#image_tag' do
    assert_match /<img src="#{Regexp.escape(@file.image.url)}".*>/, @filters.image_tag('logo.jpg')
  end

  test '#image_url' do
    assert_match @file.image.url, @filters.image_url('logo.jpg')
  end
end
