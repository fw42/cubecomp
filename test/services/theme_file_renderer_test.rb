require 'test_helper'

class ThemeFileRendererTest < ActiveSupport::TestCase
  setup do
    @competition = competitions(:aachen_open)
    @theme_file = @competition.theme_files.new(filename: 'foobar')
    @layout_theme_file = @competition.theme_files.new(filename: 'layout.html', content: '{{ content_for_layout }}')

    @competition.update_attributes(
      owner: users(:flo),
      delegate: users(:delegate)
    )

    @locale = locales(:aachen_open_english)
  end

  test '#assigns contains competition' do
    assert renderer.assigns.key?(:competition)
  end

  test '#render layout and include theme_file via {{ content_for_layout }}' do
    @layout_theme_file.content = <<-LIQUID
      {{ default_headers }}
      Aachen Open!!
      {{ content_for_layout }}
      footer
    LIQUID

    @theme_file.content = 'hello'

    expected = <<-END
      <link rel="stylesheet" media="all" href="/assets/competition_area.css" />
<script src="/assets/competition_area.js"></script>

      Aachen Open!!
      hello
      footer
  END

    assert_equal expected, renderer.render
  end

  test '#render Liquid template with competition and staff' do
    template = <<-LIQUID
      Welcome to {{ competition.name }}

      Delegate is: {{ delegate.email }}

      Owner:
        {{ owner.name }}
        {{ owner.email }}
        {{ owner.address }}

      Staff:{% for user in staff %}
        {{ user.name }}{% endfor %}
    LIQUID

    expected = <<-LIQUID
      Welcome to Aachen Open 2014

      Delegate is: delegate@wca.com

      Owner:
        Florian Weingarten
        flo@hackvalue.de
        123 Fake Street, Ottawa, Canada

      Staff:
        Regular One
        Florian Weingarten
        Regular Two
    LIQUID

    @theme_file.content = template
    assert_equal expected, renderer.render
  end

  test '#render Liquid template with competitors' do
    @theme_file.content = "{{ competitors }}"
    assert_match /<table class="competitors">/, renderer.render
  end

  test '#render Liquid template with schedule' do
    @theme_file.content = <<-LIQUID
      {% for day in days %}
        {{ day.schedule }}
      {% endfor %}
    LIQUID

    assert_match /<table class="schedule">/, renderer.render
  end

  test '#render Liquid template with news' do
    @theme_file.content = <<-LIQUID
      {{ news }}
    LIQUID

    news = @competition.news.first
    assert_match /#{Regexp.escape(news.text)}/, renderer.render
  end

  test '#render Liquid template with filename' do
    @theme_file.content = "{{ filename }}"
    assert_equal @theme_file.basename, renderer.render
  end

  test '#render Liquid template with locale' do
    @theme_file.content = "{{ locale.name }} {{ locale.handle }}"
    assert_equal "English en", renderer.render
  end

  test '#render Liquid template with filters' do
    @theme_file.content = <<-LIQUID
      {{ 'registration.flash_success' | translate }}
      Click <a href="{{ 'foobar' | theme_file_url: locale: 'foo' }}">here</a> to go back to foobar
    LIQUID

    expected = <<-LIQUID
      Registration successful. You will receive a confirmation email soon.
      Click <a href="/ao14/foo/foobar">here</a> to go back to foobar
    LIQUID

    assert_equal expected, renderer.render
  end

  test '#render renders included Liquid templates' do
    @competition.theme_files.create!(filename: 'other_file.html', content: 'other file')
    @theme_file.content = "{% include 'other_file.html' %}"
    assert_equal 'other file', renderer.render
  end

  test '#render renders included Liquid templates and uses filename with default locale if no other one exists' do
    @competition.theme_files.create!(filename: 'other_file.en.html', content: 'other english file')
    @theme_file.content = "{% include 'other_file.html' %}"
    assert_equal 'other english file', renderer.render
  end

  test '#render renders included templates but prefers filename with default locale even if exact filename exists' do
    @competition.theme_files.create!(filename: 'other_file.html', content: 'other file')
    @competition.theme_files.create!(filename: 'other_file.en.html', content: 'other english file')
    @theme_file.content = "{% include 'other_file.html' %}"
    assert_equal 'other english file', renderer.render
  end

  test '#render doesnt render included template if filename doesnt exist, even if (non-current) localized one exists' do
    @competition.theme_files.create!(filename: 'other_file.foobar.html', content: 'other foobar file')
    @theme_file.content = "{% include 'other_file.html' %}"
    assert_equal '', renderer.render
  end

  test "#render doesn't crash when including a file that doesn't exist" do
    @theme_file.content = "{% include 'doesnt.exist' %}"
    assert_equal '', renderer.render
  end

  test '#render with exceptions' do
    error_drop = Class.new(Liquid::Drop) do
      def error
        raise StandardError
      end
    end

    r = renderer
    r.assigns[:thing] = error_drop.new
    @theme_file.content = '{{ thing.error }}'
    assert_equal 'Liquid error: StandardError', r.render
  end

  test '#render uses locale' do
    @locale = locales(:aachen_open_german)
    @theme_file.content = "{{ 'registration.flash_success' | translate }}"
    assert_equal "Anmeldung erfolgreich. Du wirst bald eine Bestätigung per E-Mail erhalten.", renderer.render

    @locale = locales(:aachen_open_english)
    @theme_file.content = "{{ 'registration.flash_success' | translate }}"
    assert_equal "Registration successful. You will receive a confirmation email soon.", renderer.render
  end

  private

  def renderer
    ThemeFileRenderer.new(
      layout_theme_file: @layout_theme_file,
      theme_file: @theme_file,
      controller: ActionController::Base.new,
      locale: @locale
    )
  end
end
