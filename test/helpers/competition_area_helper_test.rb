require 'test_helper'

class CompetitionAreaHelperTest < ActionView::TestCase
  test "#amount_with_currency" do
    assert_equal "17€", amount_with_currency(17, "€")
    assert_equal "17€", amount_with_currency(17, "Euro")
    assert_equal "17€", amount_with_currency(17, "euro")
    assert_equal "17€", amount_with_currency(17, "EUR")
    assert_equal "$18", amount_with_currency(18, "$")
    assert_equal "$18", amount_with_currency(18, " dollar  ")
  end
end
