require 'test_helper'

class CompetitionDropTest < ActiveSupport::TestCase
  DELEGATIONS = [
    :name,
    :handle,
    :staff_email,
    :staff_name,
    :city_name,
    :venue_address,
    :locales
  ].freeze

  setup do
    @competition = competitions(:aachen_open)
    @drop = @competition.to_liquid
  end

  test 'Competition#to_liquid returns a CompetitionDrop' do
    assert @competition.to_liquid.is_a?(CompetitionDrop)
    assert @competition.to_liquid.is_a?(Liquid::Drop)
  end

  DELEGATIONS.each do |method|
    test "#{method} is delegated to competition" do
      assert_equal @competition.public_send(method), @drop.public_send(method)
    end
  end

  test '#country returns the name of the competition country' do
    assert_equal @competition.country.name, @drop.country
  end
end
