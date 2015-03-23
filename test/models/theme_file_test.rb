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

  test 'validates uniqueness of filename, scoped by theme' do
    theme_file = theme_files(:default_index)
    new_file = theme_file.dup
    assert_not_valid(new_file, :filename)

    new_file.theme = themes(:fancy)
    assert_valid(new_file)
  end

  test 'theme_file for theme can have same filename as another theme_file of a competition' do
    theme_file = theme_files(:default_index)
    theme_file.filename = @theme_file.filename
    assert_valid(theme_file)
  end

  test 'validates liquid syntax' do
    @theme_file.content = '{{ foo'
    assert_not_valid(@theme_file, :content)
  end

  test 'does validate presence and integrity of competition' do
    @theme_file.competition = nil
    assert_not_valid(@theme_file, :base)

    @theme_file.competition_id = 17
    assert_not_valid(@theme_file, :base)
  end

  test "can't have both a theme_id and a competition_id but requires one of them" do
    @theme_file.theme = themes(:default)
    assert_not_valid(@theme_file, :base)
  end

  test 'validates image content type' do
    file = theme_files(:aachen_open_logo)
    file.image_content_type = 'application/evil'
    assert_not_valid(file, :image_content_type)
  end

  test 'validates image file size' do
    file = theme_files(:aachen_open_logo)
    file.image_file_size = 10.megabytes
    assert_not_valid(file, :image_file_size)
  end

  test "validates that content is empty if image_content_type isn't" do
    file = theme_files(:aachen_open_logo)
    file.content = 'foobar'
    assert_not_valid(file, :content)
  end

  test 'image url' do
    file = theme_files(:aachen_open_logo)
    assert_match /logo\.png\z/, file.image.url
  end

  test '#basename' do
    assert_equal 'foobar', ThemeFile.new(filename: 'foobar.en.html').basename
    assert_equal 'foobar', ThemeFile.new(filename: 'foobar.html').basename
    assert_equal 'foobar', ThemeFile.new(filename: 'foobar').basename
  end

  test '#html?' do
    assert_equal true, ThemeFile.new(filename: 'foobar.html').html?
    assert_equal false, ThemeFile.new(filename: 'foobar.css').html?
    assert_equal true, ThemeFile.new(filename: 'foobar.en.html').html?
    assert_equal false, ThemeFile.new(filename: 'foobar.en.css').html?
  end

  test '#extension' do
    assert_equal 'html', ThemeFile.new(filename: 'foobar.html').extension
    assert_equal 'css', ThemeFile.new(filename: 'foobar.css').extension
    assert_equal 'html', ThemeFile.new(filename: 'foobar.en.html').extension
    assert_equal 'css', ThemeFile.new(filename: 'foobar.en.css').extension
    assert_equal nil, ThemeFile.new(filename: 'foobar').extension
  end
end
