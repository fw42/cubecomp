require 'test_helper'

class PageBodyTest < ActiveSupport::TestCase
  setup do
    @body = page_bodies(:aachen_open_index)
  end

  test "validates presence of content" do
    @body.content = nil
    assert_not_valid(@body, :content)

    @body.content = ''
    assert_not_valid(@body, :content)
  end
end
