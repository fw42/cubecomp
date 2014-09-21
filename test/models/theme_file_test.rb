require 'test_helper'

class ThemeFileTest < ActiveSupport::TestCase
  setup do
    @theme_file = theme_files(:aachen_open_index)
  end

  test "validates presence of filename" do
    @theme_file.filename = ''
    assert_not_valid(@theme_file, :filename)

    @theme_file.filename = nil
    assert_not_valid(@theme_file, :filename)
  end

  test "validates uniqueness of filename, scoped by competition" do
    new_file = @theme_file.dup
    assert_not_valid(new_file, :filename)

    new_file.competition = competitions(:german_open)
    assert_valid(new_file)
  end

  test "does validate presence and integrity of competition" do
    @theme_file.competition = nil
    assert_not_valid(@theme_file, :competition)

    @theme_file.competition_id = 17
    assert_not_valid(@theme_file, :competition)
  end
end
