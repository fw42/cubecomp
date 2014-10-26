require 'test_helper'

class EmailTemplateTest < ActiveSupport::TestCase
  setup do
    @template = email_templates(:aachen_open_confirmation)
  end

  test 'validates presence and integrity of competition' do
    @template.competition = nil
    assert_not_valid(@template, :competition)

    @template.competition_id = 1234
    assert_not_valid(@template, :competition)
  end

  test 'validates uniqueness of filename, scoped by competition' do
    new_template = @template.dup
    assert_not_valid(new_template, :name)

    new_template.competition = competitions(:german_open)
    assert_valid(new_template)
  end

  test 'validates liquid syntax' do
    @template.content = '{{ foo'
    assert_not_valid(@template, :content)
  end
end
