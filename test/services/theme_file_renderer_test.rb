require 'test_helper'

class ThemeFileRendererTest < ActiveSupport::TestCase
  setup do
    @competition = competitions(:aachen_open)
    @theme_file = @competition.theme_files.new(filename: 'foobar')
    @renderer = ThemeFileRenderer.new(@theme_file)
  end

  test '#assigns contains competition' do
    assert @renderer.assigns.key?(:competition)
  end

  test '#render Liquid template with competition and staff' do
    @competition.update_attributes(delegate: users(:delegate))

    template = <<-LIQUID
        Welcome to {{ competition.name }}

        Delegate is: {{ competition.delegate.email }}

        Staff:{% for user in staff %}
          {{ user.name }}{% endfor %}
    LIQUID

    expected = <<-LIQUID
        Welcome to Aachen Open 2014

        Delegate is: delegate@wca.com

        Staff:
          Regular One
          Florian Weingarten
          Regular Two
    LIQUID

    @theme_file.content = template
    assert_equal expected, @renderer.render
  end

  test '#render renders included Liquid templates' do
    @competition.theme_files.create!(filename: 'other_file.html', content: 'other file')
    @theme_file.content = "{% include 'other_file.html' %}"
    assert_equal 'other file', @renderer.render
  end

  test "#render doesn't crash when including a file that doesn't exist" do
    @theme_file.content = "{% include 'doesnt.exist' %}"
    assert_equal 'Liquid error: File does not exist', @renderer.render
  end

  test '#render with exceptions' do
    error_drop = Class.new(Liquid::Drop) do
      def error
        raise StandardError
      end
    end

    @renderer.assigns[:thing] = error_drop.new
    @theme_file.content = '{{ thing.error }}'
    assert_equal 'Liquid error: StandardError', @renderer.render
  end
end
