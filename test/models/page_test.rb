require 'test_helper'

class PageTest < ActiveSupport::TestCase
  setup do
    @page = pages(:aachen_open_index)
  end

  test "validates presence of handle" do
    @page.handle = ''
    assert_not_valid(@page, :handle)

    @page.handle = nil
    assert_not_valid(@page, :handle)
  end

  test "validates uniqueness of handle, scoped by locale" do
    new_page = @page.dup
    assert_not_valid(new_page, :handle)

    new_page.locale = locales(:aachen_open_english)
    assert_valid(new_page)
  end

  test "validates uniqueness of handle, scoped by competition" do
    new_page = @page.dup
    assert_not_valid(new_page, :handle)

    new_page.competition = competitions(:german_open)
    assert_valid(new_page)
  end

  test "validates uniqueness of locale, scoped by handle" do
    new_page = @page.dup
    assert_not_valid(new_page, :locale)

    new_page.handle = 'schedule'
    assert_valid(new_page)
  end

  test "validates uniqueness of locale, scoped by competition" do
    new_page = @page.dup
    assert_not_valid(new_page, :handle)

    new_page.competition = competitions(:german_open)
    assert_valid(new_page)
  end

  test "validates presence and integrity of body" do
    @page.body = nil
    assert_not_valid(@page, :body)

    @page.page_body_id = 17
    assert_not_valid(@page, :body)
  end

  test "does validate presence and integrity of competition" do
    @page.competition = nil
    assert_not_valid(@page, :competition)

    @page.competition_id = 17
    assert_not_valid(@page, :competition)
  end

  test "does validate presence and integrity of locale" do
    @page.locale = nil
    assert_not_valid(@page, :locale)

    @page.locale_id = 17
    assert_not_valid(@page, :locale)
  end
end
