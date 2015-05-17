require 'test_helper'

class EmailTemplateRendererTest < ActiveSupport::TestCase
  setup do
    @competition = competitions(:aachen_open)
    @template = @competition.email_templates.new(name: 'foobar')
    @competitor = competitors(:flo_aachen_open)
    @user = users(:flo)
    @renderer = EmailTemplateRenderer.new(@template, @competitor, @user)
  end

  test '#assigns contains competition' do
    assert @renderer.assigns.key?(:competition)
  end

  test '#render_content' do
    template = <<-LIQUID
      Hello {{ competitor.name }},

      you are now registered for {{ competition.name }} for the following events:
      {% for registration in competitor.registrations %}
      - {{ registration.name }} ({{ registration.day }})
      {% endfor %}

      See you,
      {{ user.name }}
    LIQUID

    expected = <<-LIQUID
      Hello #{@competitor.name},

      you are now registered for #{@competition.name} for the following events:
      
      - 3x3x3 (#{events(:aachen_open_rubiks_cube).day.date.strftime("%Y-%m-%d")})
      
      - 5x5x5 (#{events(:aachen_open_rubiks_professor).day.date.strftime("%Y-%m-%d")})
      

      See you,
      #{@user.name}
    LIQUID

    @template.content = template
    assert_equal expected, @renderer.render_content
  end

  test '#render_subject' do
    template = "[{{ competition.name }}] Registration for {{ competitor.name }}"
    expected = "[#{@competition.name}] Registration for #{@competitor.name}"
    @template.subject = template
    assert_equal expected, @renderer.render_subject
  end
end
