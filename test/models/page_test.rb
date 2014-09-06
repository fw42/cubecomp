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

  test "validates uniqueness of handle, scoped by competition" do
    new_page = @page.dup
    assert_not_valid(new_page, :handle)

    new_page.competition = competitions(:german_open)
    assert_valid(new_page)
  end

  test "validates presence and integrity of template_body" do
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
end
