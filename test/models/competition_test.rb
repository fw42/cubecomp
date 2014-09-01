require 'test_helper'

class CompetitionTest < ActiveSupport::TestCase
  setup do
    @competition = competitions(:aachen_open)
  end

  test "validates presence of name" do
    @competition.name = ""
    assert_not_valid(@competition, :name)

    @competition.name = nil
    assert_not_valid(@competition, :name)
  end

  test "validates uniqueness of name" do
    new_competition = Competition.new
    new_competition.name = @competition.name
    assert_not_valid(new_competition, :name)
  end

  test "validates presence of handle" do
    @competition.handle = ""
    assert_not_valid(@competition, :handle)

    @competition.handle = nil
    assert_not_valid(@competition, :handle)
  end

  test "validates uniqueness of handle" do
    new_competition = Competition.new
    new_competition.handle = @competition.handle
    assert_not_valid(new_competition, :handle)
  end

  test "validates presence of staff_email" do
    @competition.staff_email = ''
    assert_not_valid(@competition, :staff_email)

    @competition.staff_email = nil
    assert_not_valid(@competition, :staff_email)
  end

  test "validates format of staff_email" do
    @competition.staff_email = 'foobar'
    assert_not_valid(@competition, :staff_email)
  end

  test "validates presence of city_name" do
    @competition.city_name = ''
    assert_not_valid(@competition, :city_name)

    @competition.city_name = nil
    assert_not_valid(@competition, :city_name)
  end

  test "validates presence and integrity of country" do
    @competition.country = nil
    assert_not_valid(@competition, :country)

    @competition.country_id = 12345
    assert_not_valid(@competition, :country)
  end
end
