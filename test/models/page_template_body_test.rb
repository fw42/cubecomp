require 'test_helper'

class PageTemplateBodyTest < ActiveSupport::TestCase
  setup do
    @body = page_template_bodies(:aachen_open_index)
  end

  test "validates presence of content" do
    @body.content = nil
    assert_not_valid(@body, :content)

    @body.content = ''
    assert_not_valid(@body, :content)
  end
end
