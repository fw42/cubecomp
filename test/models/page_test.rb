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
    @page.template_body = nil
    assert_not_valid(@page, :template_body)

    @page.page_template_body_id = 17
    assert_not_valid(@page, :template_body)
  end

  test "does not validate presence of competition, but validates integrity" do
    @page.competition = nil
    assert_valid(@page)

    @page.competition_id = 17
    assert_not_valid(@page, :competition)
  end

  test "validates uniqueness of handle for nil competitions" do
    @page.competition = nil
    @page.handle = "foobar"
    other_page = @page.dup
    @page.save!
    assert_not_valid(other_page, :handle)
    other_page.handle = "blabla"
    assert_valid(other_page)
  end

  test "default_templates scope" do
    from_scope = Page.default_templates.pluck(:id).sort
    assert_equal Page.where(competition_id: nil).pluck(:id).sort, from_scope
  end
end
