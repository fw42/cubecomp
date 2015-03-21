require 'test_helper'

class LocaleDropTest < ActiveSupport::TestCase
  DELEGATIONS = [
    :name,
    :handle,
  ]

  setup do
    @locale = Locale.first
    @drop = @locale.to_liquid
  end

  test 'Competition#to_liquid returns a CompetitionDrop' do
    assert @locale.to_liquid.is_a?(LocaleDrop)
    assert @locale.to_liquid.is_a?(Liquid::Drop)
  end

  DELEGATIONS.each do |method|
    test "#{method} is delegated to competition" do
      assert_equal @locale.public_send(method), @drop.public_send(method)
    end
  end
end
