require 'test_helper'

class ThemeFileTemplateTest < ActiveSupport::TestCase
  setup do
    @template = theme_file_templates(:default_index)
  end

  test 'validates presence of filename' do
    @template.filename = ''
    assert_not_valid(@template, :filename)

    @template.filename = nil
    assert_not_valid(@template, :filename)
  end

  test 'validates uniqueness of filename, scoped by theme' do
    new_template = @template.dup
    assert_not_valid(new_template, :filename)

    new_template.theme = themes(:fancy)
    assert_valid(new_template)
  end

  test 'does validate presence and integrity of theme' do
    @template.theme = nil
    assert_not_valid(@template, :theme)

    @template.theme_id = 17
    assert_not_valid(@template, :theme)
  end
end
