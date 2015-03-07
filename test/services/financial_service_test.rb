require 'test_helper'

class FinancialServiceTest < ActiveSupport::TestCase
  setup do
    @competition = competitions(:aachen_open)
    @day = @competition.days.first
    @guest = competitors(:aachen_open_day_one_guest)
    @competitor = competitors(:flo_aachen_open)
  end

  test "#entrance_fee_from_guests and #guest_count only considers confirmed guests" do
    assert_equal 0, service.entrance_fee_from_guests(@day)
    assert_equal 0, service.guest_count(@day)

    @guest.update_attributes(state: 'confirmed')

    assert_equal @day.entrance_fee_guests, service.entrance_fee_from_guests(@day)
    assert_equal 1, service.guest_count(@day)
  end

  test "#entrance_fee_from_competing_competitors only considers confirmed competitors" do
    assert_equal 0, service.entrance_fee_from_competing_competitors(@day)
    assert_equal 0, service.competing_competitors_count(@day)

    @competitor.update_attributes(state: 'confirmed')

    assert_equal @day.entrance_fee_competitors, service.entrance_fee_from_competing_competitors(@day)
    assert_equal 1, service.competing_competitors_count(@day)
  end

  private

  def service
    FinancialService.new(@competition)
  end
end
