require 'test_helper'

class Liquid::Filters::StringTest < ActiveSupport::TestCase
  class Filters
    attr_writer :context
    include Liquid::Filters::String
  end

  setup do
    @context = Liquid::Context.new
    @filters = Filters.new
    @filters.context = @context
  end

  test "to_html converts newlines into html linebreaks" do
    assert_equal "<span>foo\n<br />bar</span>", @filters.to_html("foo\nbar")
  end
end
