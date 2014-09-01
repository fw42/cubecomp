require 'test_helper'

class CountryTest < ActiveSupport::TestCase
  setup do
    @country = countries(:germany)
  end

  test "validates presence and uniqueness of name" do
    @country.name = ''
    assert_not_valid(@country, :name)

    @country.name = nil
    assert_not_valid(@country, :name)

    @country.name = 'Germany'
    assert_valid @country

    new_country = @country.dup
    assert_not_valid(new_country, :name)
  end
end
