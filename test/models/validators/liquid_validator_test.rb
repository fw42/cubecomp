require 'test_helper'

class LiquidValidatorTest < ActiveSupport::TestCase
  class TestModel
    include ActiveModel::Validations
    attr_accessor :liquid
    validates :liquid, liquid: true
  end

  setup do
    @liquid = TestModel.new
  end

  test "valid if no liquid errors" do
    @liquid.liquid = '{% if true == true %} hello {% endif %}'
    assert_equal true, @liquid.valid?
  end

  test "validates syntax errors" do
    @liquid.liquid = '{% if'
    assert_equal false, @liquid.valid?
    expected = "contains invalid Liquid code on line 1: Tag '{%' was not properly terminated with regexp: /\\%\\}/"
    assert_equal [expected], @liquid.errors.messages[:liquid]
  end

  test "validates syntax warnings" do
    @liquid.liquid = '{{ hello. }}'
    assert_equal false, @liquid.valid?
    expected = "contains invalid Liquid code on line 1: Expected id but found end_of_string in \"{{ hello. }}\""
    assert_equal [expected], @liquid.errors.messages[:liquid]
  end
end
