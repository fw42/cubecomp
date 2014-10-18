require 'test_helper'

class ThemeFileTest < ActiveSupport::TestCase
  setup do
    @theme_file = theme_files(:aachen_open_index)
  end

  test 'validates presence of filename' do
    @theme_file.filename = ''
    assert_not_valid(@theme_file, :filename)

    @theme_file.filename = nil
    assert_not_valid(@theme_file, :filename)
  end

  test 'validates uniqueness of filename, scoped by competition' do
    new_file = @theme_file.dup
    assert_not_valid(new_file, :filename)

    new_file.competition = competitions(:german_open)
    assert_valid(new_file)
  end

  test 'validates liquid syntax' do
    @theme_file.content = '{{ foo'
    assert_not_valid(@theme_file, :content)
  end

  test 'does validate presence and integrity of competition' do
    # TODO
  end

  test 'validates image content type' do
    # TODO
  end

  test 'validates image file name' do
    # TODO
  end

  test 'validates image size' do
    # TODO
  end

  test "validates that content is empty if image_file_name isn't" do
    # TODO
  end

  test 'changing image_file_name changes filename' do
    # TODO
  end

  test 'image url' do
    # TODO
  end
end
