require 'test_helper'

class FinancialServiceTest < ActiveSupport::TestCase
  setup do
    @competition = competitions(:aachen_open)
    @day = @competition.days.first
    @guest = competitors(:aachen_open_day_one_guest)
    @competitor = competitors(:flo_aachen_open)
    @service = FinancialService.new(@competition)
  end

  test "#entrance_fee_from_guests only considers confirmed guests" do
    assert_equal 0, @service.entrance_fee_from_guests(@day)
    @guest.update_attributes(state: 'confirmed')
    assert_equal @day.entrance_fee_guests, @service.entrance_fee_from_guests(@day)
  end

  test "#entrance_fee_from_competing_competitors only considers confirmed competitors" do
    assert_equal 0, @service.entrance_fee_from_competing_competitors(@day)
    @competitor.update_attributes(state: 'confirmed')
    assert_equal @day.entrance_fee_competitors, @service.entrance_fee_from_competing_competitors(@day)
  end
end
