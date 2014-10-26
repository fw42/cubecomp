require 'test_helper'

class CompetitorDropTest < ActiveSupport::TestCase
  DELEGATIONS = [
    :name,
    :first_name,
    :last_name,
    :email
  ]

  setup do
    @competitor = competitors(:flo_aachen_open)
    @drop = @competitor.to_liquid
  end

  test 'Competitor#to_liquid returns a UserDrop' do
    assert @competitor.to_liquid.is_a?(CompetitorDrop)
    assert @competitor.to_liquid.is_a?(Liquid::Drop)
  end

  DELEGATIONS.each do |method|
    test "#{method} is delegated to competitor" do
      assert_equal @competitor.public_send(method), @drop.public_send(method)
    end
  end

  test "#registrations is delegated to competitor.event_registrations" do
    assert_equal @competitor.event_registrations, @drop.registrations
  end
end
