require 'test_helper'

class Liquid::Filters::UrlTest < ActiveSupport::TestCase
  class Filters
    attr_writer :context
    include Liquid::Filters::Url
  end

  setup do
    @context = Liquid::Context.new
    @filters = Filters.new
    @filters.context = @context
    @competition = competitions(:aachen_open)
    @context.registers[:competition] = @competition
    @context.registers[:locale] = locales(:aachen_open_german)
    @file = theme_files(:aachen_open_logo)
  end

  test '#image_tag' do
    assert_match /<img src="#{Regexp.escape(@file.image.url)}".*>/, @filters.image_tag('logo.png')
  end

  test '#image_tag for filename that does not exist returns nil' do
    assert_nil @filters.image_tag('does_not_exist.png')
  end

  test '#image_url' do
    assert_equal @file.image.url, @filters.image_url('logo.png')
  end

  test '#image_url uses localized filename if exact filename doesnt exist' do
    @file.filename = 'logo.de.png'
    @file.save!

    assert_equal @file.image.url, @filters.image_url('logo.png')
  end

  test '#image_url returns nil if locale doesnt exist, even if non-localized filename exists' do
    assert_nil @filters.image_url('logo.en.png')
  end

  test '#image_url prefers localized filename over exact filename' do
    german_file = @file.dup
    german_file.filename = 'logo.de.png'
    german_file.save!

    assert_equal german_file.image.url, @filters.image_url('logo.png')
  end

  test '#image_url for filename that does not exist returns nil' do
    assert_nil @filters.image_url('does_not_exist.png')
  end

  test '#theme_file_url strips index.html' do
    assert_equal '/ao14/de', @filters.theme_file_url('index.html')
    assert_equal '/ao14/foo', @filters.theme_file_url('index.html', 'locale' => 'foo')
  end

  test '#theme_file_url' do
    assert_equal '/ao14/de/bar.txt', @filters.theme_file_url('bar.txt')
    assert_equal '/ao14/foo/bar.txt', @filters.theme_file_url('bar.txt', 'locale' => 'foo')
  end

  test '#theme_file_url strips .html extension' do
    assert_equal '/ao14/de/disclaimer', @filters.theme_file_url('disclaimer.html')
    assert_equal '/ao14/foo/disclaimer', @filters.theme_file_url('disclaimer.html', 'locale' => 'foo')
  end
end
